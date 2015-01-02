class Encryptor
  def cipher(rotation)
    characters = (" ".."z").to_a
    rotated_characters = characters.rotate(rotation)
    Hash[characters.zip(rotated_characters)]
  end

  def encrypt_letter(letter,rotation)
    cipher_for_rotation = cipher(rotation)
    cipher_for_rotation[letter]
  end

  def encrypt(string, rotation)
    letters = string.split("")
    dl = letters.collect{|letter| encrypt_letter(letter, rotation)}
    dl.join
  end

  def decrypt(string, rotation)
    letters = string.split("")
    dl = letters.collect{|letter| encrypt_letter(letter, -rotation)}
    dl.join
  end

  def read_file(filename)
    lines = File.readlines(filename)
  end

  def write_file(filename, content)
    out = File.open(filename, "w")
    content.each{|line| out.write("#{line} \n")}
    out.close
  end

  def encrypt_file(filename, rotation)
    lines = read_file(filename)
    lines.collect! {|line| encrypt(line, rotation)}
    print lines
    name = "#{filename}.encrypted"
    write_file(name, lines)
  end
  
  def decrypt_file(filename, rotation)
    lines = read_file(filename)
    lines.collect! {|line| decrypt(line, rotation)}
    name = "#{filename}.decrypted"
    write_file(name, lines)
  end
  

end

e = Encryptor.new
e.encrypt_file("sample.txt", 13)
puts 
puts e.decrypt("Uryy!-d!$yq", 13)
puts e.decrypt("a!qn+", 13)
e.decrypt_file("sample.txt.encrypted",13)

