VhdlTestScript.scenario "./fadd.vhd" do
  clock :clk

  dependencies './priority_encoder_32to5.vhd',
    './right_barrel.vhd', './left_barrel.vhd',
    'reversed_priority-encoder-32in5out.vhd'

  filedir = File.dirname(File.expand_path(__FILE__))
  `gcc -o #{filedir}/a.out #{filedir}/testcase_maker.c`

  r_queue = [_]
  context_queue = [""]
  IO.popen("#{filedir}/a.out 5").each_line do |l|
    a, b, r = l.split(",").map { |i| i.to_i(2) }
    r_queue.push r
    context_queue.push "0b#{a.to_s(2).rjust(32, "0")} + 0b#{b.to_s(2).rjust(32, "0")} = 0b#{r.to_s(2).rjust(32, "0")}"

    context(context_queue.shift) do
      step A: a, B: b, R: r_queue.shift
    end
  end
  1.times { context(context_queue.shift) { step A: _, B: _, R: r_queue.shift }}
end


class Float
  def to_binary
    [self].pack("f").unpack("I").first
  end
end

VhdlTestScript.scenario './fadd.vhd' do
  clock :clk

  dependencies './priority_encoder_32to5.vhd',
    './right_barrel.vhd', './left_barrel.vhd',
    'reversed_priority-encoder-32in5out.vhd'

  a, b, r = [1.0.to_binary, -1.0.to_binary, 0.0.to_binary]
  context_name =  "0b#{a.to_s(2).rjust(32, "0")} + 0b#{b.to_s(2).rjust(32, "0")} = 0b#{r.to_s(2).rjust(32, "0")}"

  context(context_name) do
    step A: a, B: b, R: _
  end
  2.times { context(context_name) { step A: _, B: _, R: r }}
end
