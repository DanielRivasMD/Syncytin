#! /bin/awk -f

BEGIN{

}

{
	if ( /protein_i/ )
	{
		prot = $2;
		gsub("gb", "", prot);
		split(prot, parr, "|");
		print parr[2]
	}
}
