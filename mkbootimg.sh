STAGEZERO_LENGTH=512
STAGEONE_MAXLENGTH=8704
KERNEL_MAXLENGTH=87808

FILES_EXIST_STATUS=""
FILES_LENGTH_STATUS=""

checkFileExists(){
	file=$1
	if [ ! -e "$file" ];then
		FILES_EXIST_STATUS="$FILES_EXIST_STATUS arquivo \"$file\" nao existe...\n"
	fi
}

if [ $# -ne 4 ];then
	printf "\nsao necessarios somente quatro parametros:\n"
	printf "\n\t\tnome do arquivo de imagem - arquivo que sera gerado por mim..."
	printf "\n\t\tnome do arquivo stage_zero..."
	printf "\n\t\tnome do arquivo stage_one..."
	printf "\n\t\tnome do arquivo kernel..."
	printf "\n"
	exit 1
fi

target_file=$1
stagezero_file=$2
stageone_file=$3
kernel_file=$4

checkFileExists "$stagezero_file"
checkFileExists "$stageone_file"
checkFileExists "$kernel_file"

if [ "$FILES_EXIST_STATUS" != "" ]; then
	printf "\n$FILES_EXIST_STATUS"
	printf "\n"
	exit 1
fi


stagezero_file_length=$(ls -l "$stagezero_file" | awk '{print $5}')
stageone_file_length=$(ls -l "$stageone_file" 	| awk '{print $5}')
kernel_file_length=$(ls -l "$kernel_file" 		| awk '{print $5}')

if [ "$stagezero_file_length" -ne "$STAGEZERO_LENGTH" ]; then
	FILES_LENGTH_STATUS="$FILES_LENGTH_STATUS arquivo \"$stagezero_file\" difere de seu tamanho essencial de $STAGEZERO_LENGTH\n";
fi	

if [ "$stageone_file_length" -gt "$STAGEONE_MAXLENGTH" ]; then
	FILES_LENGTH_STATUS="$FILES_LENGTH_STATUS arquivo \"$stageone_file\" excedeu seu tamanho maximo de $STAGEONE_MAXLENGTH\n";
fi	

if [ "$kernel_file_length" -gt "$KERNEL_MAXLENGTH" ]; then
	FILES_LENGTH_STATUS="$FILES_LENGTH_STATUS arquivo \"$kernel_file\" excedeu seu tamanho maximo de $KERNEL_MAXLENGTH\n";
fi	

if [ "$FILES_LENGTH_STATUS" != "" ]; then
	printf "\n$FILES_LENGTH_STATUS"
	exit 1
fi	

CYLY_STAGES_SECTORS_LENGTH=18432
CYLYS_STAGES_LENGTH=$(expr "$stagezero_file_length" + "$stageone_file_length" )
CYLYS_STAGES_FILL_WITHZERO=$(expr "$CYLY_STAGES_SECTORS_LENGTH" - "$CYLYS_STAGES_LENGTH" )

DISK_LENGTH=1474560
DISK_FILLED_BINARIES=$(expr "$stagezero_file_length" + "$stageone_file_length" + "$kernel_file_length" + "$CYLYS_STAGES_FILL_WITHZERO")
DISK_FILL_WITHZERO=$(expr "$DISK_LENGTH" - "$DISK_FILLED_BINARIES" )


cat "$stagezero_file" > "$target_file"
cat "$stageone_file" >> "$target_file"
dd if=/dev/zero  bs="$CYLYS_STAGES_FILL_WITHZERO" count=1 >> "$target_file"
cat "$kernel_file" >> "$target_file"
dd if=/dev/zero  bs="$DISK_FILL_WITHZERO" count=1 >> "$target_file"