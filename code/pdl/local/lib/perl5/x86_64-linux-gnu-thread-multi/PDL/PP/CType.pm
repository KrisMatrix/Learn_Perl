# Represent any C type.
# Type contains the size of arrays, which is either constant
# or resolved (into an object) from resolveobj.

package PDL::PP::CType;
use strict;
use warnings;
use Carp;

# new PDL::PP::CType(resolveobj,str)

sub new {
	my $this = bless {},shift;
	$this->parsefrom(shift) if @_;
	return $this;
}

sub stripptrs {
	my($this,$str) = @_;
	if($str =~ s/^\s*(\w+)\s*$/$1/g) {
		$this->{ProtoName} = $str;
		return [];
	}
	# Now, recall the different C syntaxes. First priority is a pointer:
	return [["PTR"], @{$this->stripptrs($1)}] if $str =~ /^\s*\*(.*)$/;
	return $this->stripptrs($1) if $str =~ /^\s*\(.*\)\s*$/; # XXX Should try to see if a funccall.
	return [["ARR",$2], @{$this->stripptrs($1)}] if $str =~ /^(.*)\[([^]]*)\]\s*$/;
	Carp::confess("Invalid C type '$str'");
}

# XXX Correct to *real* parsing. This is only a subset.
sub parsefrom {
	my($this,$str) = @_;
# First, take the words in the beginning
	$str =~ /^\s*((?:\w+\b\s*)+)([^[].*)$/;
	$this->{Base} = $1;
	$this->{Chain} = $this->stripptrs($2);
}

sub get_decl {
	my($this,$name,$opts) = @_;
	for(@{$this->{Chain}}) {
		my ($type, $arg) = @$_;
		if($type eq "PTR") {$name = "*$name"}
		elsif($type eq "ARR") {
			if($opts->{VarArrays2Ptrs}) {
				$name = "*$name";
			} else {
				$name = "($name)[$arg]";
			}
		} else { confess("Invalid decl @$_") }
	}
	return "$this->{Base} $name";
}

# Useful when parsing argument decls
sub protoname { return shift->{ProtoName} }

sub get_copy {
	my($this,$from,$to) = @_;
	return "($to) = ($from);" if !@{$this->{Chain}};
	# strdup loses portability :(
	return "($to) = malloc(strlen($from)+1); strcpy($to,$from);"
	 if $this->{Base} =~ /^\s*char\s*$/;
	return "($to) = newSVsv($from);" if $this->{Base} =~ /^\s*SV\s*$/;
	my $code = $this->get_malloc($to,$from);
	return "($to) = ($from);" if !defined $code; # pointer
	my ($deref0,$deref1,$prev,$close) = ($from,$to);
        my $no = 0;
	for(@{$this->{Chain}}) {
		my ($type, $arg) = @$_;
		if($type eq "PTR") {confess("Cannot copy pointer, must be array");}
		elsif($type eq "ARR") {
			$no++;
			$arg = "$this->{ProtoName}_count" if $this->is_array;
			$prev .= PDL::PP::pp_line_numbers(__LINE__-1, "
			  if(!$deref0) {$deref1=0;}
			  else {int __malloc_ind_$no;
				for(__malloc_ind_$no = 0;
					__malloc_ind_$no < $arg;
					__malloc_ind_$no ++) {");
			$deref0 = $deref0."[__malloc_ind_$no]";
			$deref1 = $deref1."[__malloc_ind_$no]";
			$close .= "}}";
		} else { confess("Invalid decl @$_") }
	}
	$code .= "$prev $deref1 = $deref0; $close";
	return $code;
}

sub get_free {
	my($this,$from) = @_;
	return "" if !@{$this->{Chain}} or $this->{Chain}[0][0] eq 'PTR';
	return "free($from);" if $this->{Base} =~ /^\s*char\s*$/;
	return "SvREFCNT_dec($from);" if $this->{Base} =~ /^\s*SV\s*$/;
	croak("Can only free one layer!\n") if @{$this->{Chain}} > 1;
	"free($from);";
}

sub need_malloc {
	my($this) = @_;
	grep /(ARR|PTR)/, map $_->[0], @{$this->{Chain}};
}

# returns with the array string - undef if a pointer not needing malloc
sub get_malloc {
  my($this,$assignto) = @_;
  my $str = "";
  for(@{$this->{Chain}}) {
    my ($type, $arg) = @$_;
    if($type eq "PTR") {return}
    elsif($type eq "ARR") {
      $arg = "$this->{ProtoName}_count" if $this->is_array;
      $str .= PDL::PP::pp_line_numbers(__LINE__-1, "$assignto = malloc(sizeof(*$assignto) * $arg);\n");
    } else { confess("Invalid decl (@$_)") }
  }
  return $str;
}

sub is_array {
  my ($self) = @_;
  @{$self->{Chain}} &&
    @{$self->{Chain}[0]} &&
    $self->{Chain}[0][0] eq 'ARR' &&
    !$self->{Chain}[0][1];
}

1;
