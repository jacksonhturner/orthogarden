process MSTATX{
    label 'mstatx'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/mstatx", mode: "copy")

    input:
      path(trimal)

    output:
        path("*.mstatx"), emit: mstatx_ch

    script:
        """
        echo "H HENS920102" > matrix.mat
        echo "D BLOSUM62 substitution matrix (Henikoff-Henikoff, 1992)" >> matrix.mat
        echo "R LIT:1902106 PMID:1438297" >> matrix.mat
        echo "A Henikoff, S. and Henikoff, J.G." >> matrix.mat
        echo "T Amino acid substitution matrices from protein blocks" >> matrix.mat
        echo "J Proc. Natl. Acad. Sci. USA 89, 10915-10919 (1992)" >> matrix.mat
        echo "* matrix in 1/3 Bit Units" >> matrix.mat
        echo "M rows = ARNDCQEGHILKMFPSTWYV, cols = ARNDCQEGHILKMFPSTWYV" >> matrix.mat
        echo "6." >> matrix.mat
        echo "-2.      8." >> matrix.mat
        echo "-2.     -1.      8." >> matrix.mat
        echo "-3.     -2.      2.      9." >> matrix.mat
        echo "-1.     -5.     -4.     -5.     13." >> matrix.mat
        echo "-1.      1.      0.      0.     -4.      8." >> matrix.mat
        echo "-1.      0.      0.      2.     -5.      3.      7." >> matrix.mat
        echo "0.     -3.     -1.     -2.     -4.     -3.     -3.      8." >> matrix.mat
        echo "-2.      0.      1.     -2.     -4.      1.      0.     -3.     11." >> matrix.mat
        echo "-2.     -4.     -5.     -5.     -2.     -4.     -5.     -6.     -5.      6." >> matrix.mat
        echo "-2.     -3.     -5.     -5.     -2.     -3.     -4.     -5.     -4.      2.      6." >> matrix.mat
        echo "-1.      3.      0.     -1.     -5.      2.      1.     -2.     -1.     -4.     -4.      7." >> matrix.mat
        echo "-1.     -2.     -3.     -5.     -2.     -1.     -3.     -4.     -2.      2.      3.     -2.      8." >> matrix.mat
        echo "-3.     -4.     -4.     -5.     -4.     -5.     -5.     -5.     -2.      0.      1.     -5.      0.      9." >> matrix.mat
        echo "-1.     -3.     -3.     -2.     -4.     -2.     -2.     -3.     -3.     -4.     -4.     -2.     -4.     -5.     11." >> matrix.mat
        echo "2.     -1.      1.      0.     -1.      0.      0.      0.     -1.     -4.     -4.      0.     -2.     -4.     -1.      6." >> matrix.mat
        echo "0.     -2.      0.     -2.     -1.     -1.     -1.     -2.     -3.     -1.     -2.     -1.     -1.     -3.     -2.      2.      7." >> matrix.mat
        echo "-4.     -4.     -6.     -6.     -3.     -3.     -4.     -4.     -4.     -4.     -2.     -4.     -2.      1.     -5.     -4.     -4.     16." >> matrix.mat
        echo "-3.     -3.     -3.     -5.     -4.     -2.     -3.     -5.      3.     -2.     -2.     -3.     -1.      4.     -4.     -3.     -2.      3.     10." >> matrix.mat
        echo "0.     -4.     -4.     -5.     -1.     -3.     -4.     -5.     -5.      4.      1.     -3.      1.     -1.     -4.     -2.      0.     -4.     -2.      6." >> matrix.mat
        echo "//" >> matrix.mat

        for seq in *masked; do
            mstatx -i \${seq} -s trident -m matrix.mat -o \${seq}.mstatx;
            sed 's/.*\t//g' \${seq}.mstatx > tmp && mv tmp \${seq}.mstatx;
        done
        """
}
