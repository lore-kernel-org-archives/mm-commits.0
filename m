From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:59 -0800
Message-ID: <58b5e2ef.IsAi9pUPtGIUvDgJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751935AbdB1UwA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:52:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "followings" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "followings" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  followings||following

While we are here, add a missing colon in the boilerplate in DT
binding documents.  The "you SoC" in allwinner,sunxi-pinctrl.txt
was fixed as well.

I reworded "as the followings:" to "as follows:" for
drivers/usb/gadget/udc/renesas_usb3.c.

Link: http://lkml.kernel.org/r/1481573103-11329-32-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/libata.tmpl                                     |    2 +-
 Documentation/acpi/method-tracing.txt                                 |    2 +-
 Documentation/blockdev/mflash.txt                                     |    2 +-
 Documentation/devicetree/bindings/net/marvell-armada-370-neta.txt     |    2 +-
 Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt |    2 +-
 Documentation/devicetree/bindings/soc/rockchip/grf.txt                |    4 ++--
 Documentation/devicetree/bindings/sound/rockchip-i2s.txt              |    4 ++--
 Documentation/devicetree/bindings/sound/sun4i-codec.txt               |    2 +-
 Documentation/devicetree/bindings/sound/sun4i-i2s.txt                 |    4 ++--
 Documentation/memory-hotplug.txt                                      |    4 ++--
 Documentation/sound/hd-audio/notes.rst                                |    2 +-
 drivers/ata/libata-eh.c                                               |    2 +-
 drivers/atm/iphase.c                                                  |    2 +-
 drivers/atm/iphase.h                                                  |    2 +-
 drivers/devfreq/devfreq.c                                             |    2 +-
 drivers/hwmon/g762.c                                                  |    2 +-
 drivers/isdn/hardware/eicon/debug.c                                   |    2 +-
 drivers/pci/quirks.c                                                  |    2 +-
 drivers/staging/gs_fpgaboot/gs_fpgaboot.h                             |    2 +-
 drivers/usb/gadget/udc/renesas_usb3.c                                 |    4 ++--
 include/linux/kconfig.h                                               |    2 +-
 mm/percpu.c                                                           |    2 +-
 scripts/spelling.txt                                                  |    1 +
 sound/pci/hda/patch_ca0132.c                                          |    2 +-
 sound/ppc/snd_ps3.c                                                   |    2 +-
 sound/soc/fsl/fsl_asrc.c                                              |    2 +-
 26 files changed, 31 insertions(+), 30 deletions(-)

diff -puN Documentation/DocBook/libata.tmpl~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances Documentation/DocBook/libata.tmpl
--- a/Documentation/DocBook/libata.tmpl~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/Documentation/DocBook/libata.tmpl
@@ -1020,7 +1020,7 @@ and other resources, etc.
 	</itemizedlist>
 
 	<para>
-	Of errors detected as above, the followings are not ATA/ATAPI
+	Of errors detected as above, the following are not ATA/ATAPI
 	device errors but ATA bus errors and should be handled
 	according to <xref linkend="excatATAbusErr"/>.
 	</para>
diff -puN Documentation/acpi/method-tracing.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances Documentation/acpi/method-tracing.txt
--- a/Documentation/acpi/method-tracing.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/Documentation/acpi/method-tracing.txt
@@ -152,7 +152,7 @@ tracing facility.
 	Users can enable/disable this debug tracing feature by executing
 	the following command:
 	    # echo string > /sys/module/acpi/parameters/trace_state
-	Where "string" should be one of the followings:
+	Where "string" should be one of the following:
 	"disable"
 	    Disable the method tracing feature.
 	"enable"
diff -puN Documentation/blockdev/mflash.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances Documentation/blockdev/mflash.txt
--- a/Documentation/blockdev/mflash.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/Documentation/blockdev/mflash.txt
@@ -17,7 +17,7 @@ driver and currently works well under st
 one chip SSD. IO mode is ATA-like custom mode for the host that doesn't have
 IDE interface.
 
-Followings are brief descriptions about IO mode.
+Following are brief descriptions about IO mode.
 A. IO mode based on ATA protocol and uses some custom command. (read confirm,
 write confirm)
 B. IO mode uses SRAM bus interface.
diff -puN Documentation/devicetree/bindings/net/marvell-armada-370-neta.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances Documentation/devicetree/bindings/net/marvell-armada-370-neta.txt
--- a/Documentation/devicetree/bindings/net/marvell-armada-370-neta.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/Documentation/devicetree/bindings/net/marvell-armada-370-neta.txt
@@ -1,7 +1,7 @@
 * Marvell Armada 370 / Armada XP / Armada 3700 Ethernet Controller (NETA)
 
 Required properties:
-- compatible: could be one of the followings
+- compatible: could be one of the following:
 	"marvell,armada-370-neta"
 	"marvell,armada-xp-neta"
 	"marvell,armada-3700-neta"
diff -puN Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
--- a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
@@ -6,7 +6,7 @@ the first two functions being GPIO in an
 the pins includes drive strength and pull-up.
 
 Required properties:
-- compatible: Should be one of the followings (depending on you SoC):
+- compatible: Should be one of the following (depending on your SoC):
   "allwinner,sun4i-a10-pinctrl"
   "allwinner,sun5i-a10s-pinctrl"
   "allwinner,sun5i-a13-pinctrl"
diff -puN Documentation/devicetree/bindings/soc/rockchip/grf.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances Documentation/devicetree/bindings/soc/rockchip/grf.txt
--- a/Documentation/devicetree/bindings/soc/rockchip/grf.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/Documentation/devicetree/bindings/soc/rockchip/grf.txt
@@ -10,7 +10,7 @@ From RK3368 SoCs, the GRF is divided int
 
 Required Properties:
 
-- compatible: GRF should be one of the followings
+- compatible: GRF should be one of the following:
    - "rockchip,rk3036-grf", "syscon": for rk3036
    - "rockchip,rk3066-grf", "syscon": for rk3066
    - "rockchip,rk3188-grf", "syscon": for rk3188
@@ -18,7 +18,7 @@ Required Properties:
    - "rockchip,rk3288-grf", "syscon": for rk3288
    - "rockchip,rk3368-grf", "syscon": for rk3368
    - "rockchip,rk3399-grf", "syscon": for rk3399
-- compatible: PMUGRF should be one of the followings
+- compatible: PMUGRF should be one of the following:
    - "rockchip,rk3368-pmugrf", "syscon": for rk3368
    - "rockchip,rk3399-pmugrf", "syscon": for rk3399
 - compatible: SGRF should be one of the following
diff -puN Documentation/devicetree/bindings/sound/rockchip-i2s.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances Documentation/devicetree/bindings/sound/rockchip-i2s.txt
--- a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
@@ -5,7 +5,7 @@ audio data transfer between devices in t
 
 Required properties:
 
-- compatible: should be one of the followings
+- compatible: should be one of the following:
    - "rockchip,rk3066-i2s": for rk3066
    - "rockchip,rk3188-i2s", "rockchip,rk3066-i2s": for rk3188
    - "rockchip,rk3288-i2s", "rockchip,rk3066-i2s": for rk3288
@@ -17,7 +17,7 @@ Required properties:
 	Documentation/devicetree/bindings/dma/dma.txt
 - dma-names: should include "tx" and "rx".
 - clocks: a list of phandle + clock-specifer pairs, one for each entry in clock-names.
-- clock-names: should contain followings:
+- clock-names: should contain the following:
    - "i2s_hclk": clock for I2S BUS
    - "i2s_clk" : clock for I2S controller
 - rockchip,playback-channels: max playback channels, if not set, 8 channels default.
diff -puN Documentation/devicetree/bindings/sound/sun4i-codec.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances Documentation/devicetree/bindings/sound/sun4i-codec.txt
--- a/Documentation/devicetree/bindings/sound/sun4i-codec.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/Documentation/devicetree/bindings/sound/sun4i-codec.txt
@@ -14,7 +14,7 @@ Required properties:
 - dma-names: should include "tx" and "rx".
 - clocks: a list of phandle + clock-specifer pairs, one for each entry
   in clock-names.
-- clock-names: should contain followings:
+- clock-names: should contain the following:
    - "apb": the parent APB clock for this controller
    - "codec": the parent module clock
 
diff -puN Documentation/devicetree/bindings/sound/sun4i-i2s.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances Documentation/devicetree/bindings/sound/sun4i-i2s.txt
--- a/Documentation/devicetree/bindings/sound/sun4i-i2s.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/Documentation/devicetree/bindings/sound/sun4i-i2s.txt
@@ -5,7 +5,7 @@ audio data transfer between devices in t
 
 Required properties:
 
-- compatible: should be one of the followings
+- compatible: should be one of the following:
    - "allwinner,sun4i-a10-i2s"
    - "allwinner,sun6i-a31-i2s"
 - reg: physical base address of the controller and length of memory mapped
@@ -15,7 +15,7 @@ Required properties:
 	Documentation/devicetree/bindings/dma/dma.txt
 - dma-names: should include "tx" and "rx".
 - clocks: a list of phandle + clock-specifer pairs, one for each entry in clock-names.
-- clock-names: should contain followings:
+- clock-names: should contain the following:
    - "apb" : clock for the I2S bus interface
    - "mod" : module clock for the I2S controller
 - #sound-dai-cells : Must be equal to 0
diff -puN Documentation/memory-hotplug.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/Documentation/memory-hotplug.txt
@@ -114,11 +114,11 @@ config options.
     Memory model -> Sparse Memory  (CONFIG_SPARSEMEM)
     Allow for memory hot-add       (CONFIG_MEMORY_HOTPLUG)
 
-- To enable memory removal, the followings are also necessary
+- To enable memory removal, the following are also necessary
     Allow for memory hot remove    (CONFIG_MEMORY_HOTREMOVE)
     Page Migration                 (CONFIG_MIGRATION)
 
-- For ACPI memory hotplug, the followings are also necessary
+- For ACPI memory hotplug, the following are also necessary
     Memory hotplug (under ACPI Support menu) (CONFIG_ACPI_HOTPLUG_MEMORY)
     This option can be kernel module.
 
diff -puN Documentation/sound/hd-audio/notes.rst~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances Documentation/sound/hd-audio/notes.rst
--- a/Documentation/sound/hd-audio/notes.rst~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/Documentation/sound/hd-audio/notes.rst
@@ -697,7 +697,7 @@ If it's a regression, at best, send alsa
 and non-working kernels.  This is really helpful because we can
 compare the codec registers directly.
 
-Send a bug report either the followings:
+Send a bug report either the following:
 
 kernel-bugzilla
     https://bugzilla.kernel.org/
diff -puN drivers/ata/libata-eh.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances drivers/ata/libata-eh.c
--- a/drivers/ata/libata-eh.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/drivers/ata/libata-eh.c
@@ -2034,7 +2034,7 @@ static int speed_down_verdict_cb(struct
  *	This is to expedite speed down decisions right after device is
  *	initially configured.
  *
- *	The followings are speed down rules.  #1 and #2 deal with
+ *	The following are speed down rules.  #1 and #2 deal with
  *	DUBIOUS errors.
  *
  *	1. If more than one DUBIOUS_ATA_BUS or DUBIOUS_TOUT_HSM errors
diff -puN drivers/atm/iphase.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances drivers/atm/iphase.c
--- a/drivers/atm/iphase.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/drivers/atm/iphase.c
@@ -21,7 +21,7 @@
       supports a variety of varients of Interphase ATM PCI (i)Chip adapter 
       card family (See www.iphase.com/products/ClassSheet.cfm?ClassID=ATM) 
       in terms of PHY type, the size of control memory and the size of 
-      packet memory. The followings are the change log and history:
+      packet memory. The following are the change log and history:
      
           Bugfix the Mona's UBR driver.
           Modify the basic memory allocation and dma logic.
diff -puN drivers/atm/iphase.h~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances drivers/atm/iphase.h
--- a/drivers/atm/iphase.h~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/drivers/atm/iphase.h
@@ -21,7 +21,7 @@
       supports a variety of varients of Interphase ATM PCI (i)Chip adapter 
       card family (See www.iphase.com/products/ClassSheet.cfm?ClassID=ATM) 
       in terms of PHY type, the size of control memory and the size of 
-      packet memory. The followings are the change log and history:
+      packet memory. The following are the change log and history:
      
           Bugfix the Mona's UBR driver.
           Modify the basic memory allocation and dma logic.
diff -puN drivers/devfreq/devfreq.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances drivers/devfreq/devfreq.c
--- a/drivers/devfreq/devfreq.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/drivers/devfreq/devfreq.c
@@ -1228,7 +1228,7 @@ static int __init devfreq_init(void)
 subsys_initcall(devfreq_init);
 
 /*
- * The followings are helper functions for devfreq user device drivers with
+ * The following are helper functions for devfreq user device drivers with
  * OPP framework.
  */
 
diff -puN drivers/hwmon/g762.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances drivers/hwmon/g762.c
--- a/drivers/hwmon/g762.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/drivers/hwmon/g762.c
@@ -861,7 +861,7 @@ static ssize_t fan1_pulses_store(struct
  * (i.e. closed or open-loop).
  *
  * Following documentation about hwmon's sysfs interface, a pwm1_enable node
- * should accept followings:
+ * should accept the following:
  *
  *  0 : no fan speed control (i.e. fan at full speed)
  *  1 : manual fan speed control enabled (use pwm[1-*]) (open-loop)
diff -puN drivers/isdn/hardware/eicon/debug.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances drivers/isdn/hardware/eicon/debug.c
--- a/drivers/isdn/hardware/eicon/debug.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/drivers/isdn/hardware/eicon/debug.c
@@ -2049,7 +2049,7 @@ static int diva_dbg_cmp_key(const char *
 /*
   In case trace filter starts with "C" character then
   all following characters are interpreted as command.
-  Followings commands are available:
+  Following commands are available:
   - single, trace single call at time, independent from CPN/CiPN
 */
 static int diva_mnt_cmp_nmbr(const char *nmbr) {
diff -puN drivers/pci/quirks.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/drivers/pci/quirks.c
@@ -3630,7 +3630,7 @@ static int __init pci_apply_final_quirks
 fs_initcall_sync(pci_apply_final_quirks);
 
 /*
- * Followings are device-specific reset methods which can be used to
+ * Following are device-specific reset methods which can be used to
  * reset a single function if other methods (e.g. FLR, PM D0->D3) are
  * not available.
  */
diff -puN drivers/staging/gs_fpgaboot/gs_fpgaboot.h~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances drivers/staging/gs_fpgaboot/gs_fpgaboot.h
--- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.h~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/drivers/staging/gs_fpgaboot/gs_fpgaboot.h
@@ -39,7 +39,7 @@ struct fpgaimage {
 	const struct	firmware	*fw_entry;
 
 	/*
-	 * the followings can be read from bitstream,
+	 * the following can be read from bitstream,
 	 * but other image format should have as well
 	 */
 	char	filename[MAX_STR];
diff -puN drivers/usb/gadget/udc/renesas_usb3.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances drivers/usb/gadget/udc/renesas_usb3.c
--- a/drivers/usb/gadget/udc/renesas_usb3.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/drivers/usb/gadget/udc/renesas_usb3.c
@@ -1791,7 +1791,7 @@ static int renesas_usb3_init_ep(struct r
 
 	dev_dbg(dev, "%s: num_usb3_eps = %d\n", __func__, usb3->num_usb3_eps);
 	/*
-	 * This driver prepares pipes as the followings:
+	 * This driver prepares pipes as follows:
 	 *  - odd pipes = IN pipe
 	 *  - even pipes = OUT pipe (except pipe 0)
 	 */
@@ -1841,7 +1841,7 @@ static void renesas_usb3_init_ram(struct
 	memset(basead, 0, sizeof(basead));
 
 	/*
-	 * This driver prepares pipes as the followings:
+	 * This driver prepares pipes as follows:
 	 *  - all pipes = the same size as "ramsize_per_pipe"
 	 * Please refer to the "Method of Specifying RAM Mapping"
 	 */
diff -puN include/linux/kconfig.h~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances include/linux/kconfig.h
--- a/include/linux/kconfig.h~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/include/linux/kconfig.h
@@ -8,7 +8,7 @@
 
 /*
  * The use of "&&" / "||" is limited in certain expressions.
- * The followings enable to calculate "and" / "or" with macro expansion only.
+ * The following enable to calculate "and" / "or" with macro expansion only.
  */
 #define __and(x, y)			___and(x, y)
 #define ___and(x, y)			____and(__ARG_PLACEHOLDER_##x, y)
diff -puN mm/percpu.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances mm/percpu.c
--- a/mm/percpu.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/mm/percpu.c
@@ -43,7 +43,7 @@
  * Chunks can be determined from the address using the index field
  * in the page struct. The index field contains a pointer to the chunk.
  *
- * To use this allocator, arch code should do the followings.
+ * To use this allocator, arch code should do the following:
  *
  * - define __addr_to_pcpu_ptr() and __pcpu_ptr_to_addr() to translate
  *   regular address to percpu pointer and back if they need to be
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -464,6 +464,7 @@ finsih||finish
 flusing||flushing
 folloing||following
 followign||following
+followings||following
 follwing||following
 forseeable||foreseeable
 forse||force
diff -puN sound/pci/hda/patch_ca0132.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances sound/pci/hda/patch_ca0132.c
--- a/sound/pci/hda/patch_ca0132.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/sound/pci/hda/patch_ca0132.c
@@ -2866,7 +2866,7 @@ static unsigned int ca0132_capture_pcm_d
 #define CA0132_CODEC_MUTE(xname, nid, dir) \
 	CA0132_CODEC_MUTE_MONO(xname, nid, 3, dir)
 
-/* The followings are for tuning of products */
+/* The following are for tuning of products */
 #ifdef ENABLE_TUNING_CONTROLS
 
 static unsigned int voice_focus_vals_lookup[] = {
diff -puN sound/ppc/snd_ps3.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances sound/ppc/snd_ps3.c
--- a/sound/ppc/snd_ps3.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/sound/ppc/snd_ps3.c
@@ -883,7 +883,7 @@ static void snd_ps3_audio_set_base_addr(
 static void snd_ps3_audio_fixup(struct snd_ps3_card_info *card)
 {
 	/*
-	 * avsetting driver seems to never change the followings
+	 * avsetting driver seems to never change the following
 	 * so, init them here once
 	 */
 
diff -puN sound/soc/fsl/fsl_asrc.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances sound/soc/fsl/fsl_asrc.c
--- a/sound/soc/fsl/fsl_asrc.c~scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances
+++ a/sound/soc/fsl/fsl_asrc.c
@@ -368,7 +368,7 @@ static int fsl_asrc_config_pair(struct f
 	fsl_asrc_set_watermarks(pair, ASRC_INPUTFIFO_THRESHOLD,
 				ASRC_INPUTFIFO_THRESHOLD);
 
-	/* Configure the followings only for Ideal Ratio mode */
+	/* Configure the following only for Ideal Ratio mode */
 	if (!ideal)
 		return 0;
 
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch

