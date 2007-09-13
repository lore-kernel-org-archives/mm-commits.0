From: akpm@linux-foundation.org
Subject: + documentation-delete-unreferenced-xterm-linuxxpm-file.patch added to -mm tree
Date: Thu, 13 Sep 2007 15:13:23 -0700
Message-ID: <200709132213.l8DMDNdP008498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758234AbXIMWN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 18:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Documentation: delete unreferenced xterm-linux.xpm file
has been added to the -mm tree.  Its filename is
     documentation-delete-unreferenced-xterm-linuxxpm-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation: delete unreferenced xterm-linux.xpm file
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX        |    2 -
 Documentation/xterm-linux.xpm |   61 --------------------------------
 2 files changed, 63 deletions(-)

diff -puN Documentation/00-INDEX~documentation-delete-unreferenced-xterm-linuxxpm-file Documentation/00-INDEX
--- a/Documentation/00-INDEX~documentation-delete-unreferenced-xterm-linuxxpm-file
+++ a/Documentation/00-INDEX
@@ -420,7 +420,5 @@ watchdog/
 	- how to auto-reboot Linux if it has "fallen and can't get up". ;-)
 x86_64/
 	- directory with info on Linux support for AMD x86-64 (Hammer) machines.
-xterm-linux.xpm
-	- XPM image of penguin logo (see logo.txt) sitting on an xterm.
 zorro.txt
 	- info on writing drivers for Zorro bus devices found on Amigas.
diff -puN Documentation/xterm-linux.xpm~documentation-delete-unreferenced-xterm-linuxxpm-file /dev/null
--- a/Documentation/xterm-linux.xpm
+++ /dev/null
@@ -1,61 +0,0 @@
-/* XPM */
-/*****************************************************************************/
-/**       This pixmap was made by Torsten Poulin - 1996 - torsten@diku.dk   **/
-/**       It was made by combining xterm-blank.xpm with                     **/
-/**       the wonderfully cute Linux penguin mascot by Larry Ewing.         **/
-/**       I had to change Larry's penguin a little to make it fit.          **/
-/**       xterm-blank.xpm contained the following comment:                  **/
-/**       This pixmap is kindly offered by Ion Cionca - 1992 -              **/
-/**       Swiss Federal Institute of Technology                             **/
-/**       Central Computing Service                                         **/
-/*****************************************************************************/
-static char * image_name [] = {
-/**/
-"64 38 8 1",
-/**/
-" 	s mask	c none",
-".	c gray70",
-"X	c gray85",
-"o	c gray50",
-"O	c yellow",
-"+	c darkolivegreen",
-"@	c white",
-"#	c black",
-"              ######                                            ",
-"             ########                                           ",
-"            ##########    ...........................           ",
-"            ###########  .XXXXXXXXXXXXXXXXXXXXXXXXXXX.          ",
-"            ########### .XXXXXXXXXXXXXXXXXXXXXXXXXXXXXoo        ",
-"            #@@@#@@@### .XX+++++++++++++++++++++++XXXXoo        ",
-"            #@#@#@#@### .XX++++++++++++++++++++++++XXXooo       ",
-"            #@#####@### .XX++@@+@++@+@@@@++@+++++++XXXooo       ",
-"            ###OOO######.XX++++++++++++++++++++++++XXXoooo      ",
-"            ##OOOOOO####.XX++@@@@+@@+@@@+++++++++++XXXoooo      ",
-"            #O#OOO#O####.XX++++++++++++++++++++++++XXXooooo     ",
-"            ##O###OO####.XX++@@@@@@@@@@+@@@@@++++++XXXooooo     ",
-"            ###OOOO@#####XX++++++++++++++++++++++++XXXooooo     ",
-"           ##@###@@@@####XX++@@@+@@@@+@@++@@@++++++XXXooooo     ",
-"           #@@@@@@@@@@####X++++++++++++++++++++++++XXXooooo     ",
-"          ##@@@@@@@@@@#####++@+++++++++++++++++++++XXXooooo     ",
-"         ###@@@@@@@@@@######+++++++++++++++++++++++XXXooooo     ",
-"        ####@@@@@@@@@@@#####+@@@@+@+@@@+@++++++++++XXXooooo     ",
-"        ###@@@@@@@@@@@@######++++++++++++++++++++++XXXooooo     ",
-"        ##@@@@@@@@@@@@@@#####@+@@@@++++++++++++++++XXXooooo     ",
-"       ###@@@@@@@@@@@@@@######++++++++++++++++++++XXXXoooo      ",
-"       ###@@@@@@@@@@@@@@######XXXXXXXXXXXXXXXXXXXXXXXXooo       ",
-"      ###@@@@@@@@@@@@@@@######XXXXXXXXXXXXXXXXXXXXXXXooo        ",
-"      ###@@@@@@@@@@@@@@@@#####ooooooooooooooooooooooo...oo      ",
-"      ###@@@@@@@@@@@@@@@######.........................ooo      ",
-"     #OO##@@@@@@@@@@@@@#######oooooooooooooooooooooooooooo      ",
-"     #OOO##@@@@@@@@@@@#OO####O#XXXXXXXXXXXXXXXXXXXXXXXoooo.. .. ",
-"  ###OOOOO##@@@@@@@@@@#OOO#OOO#XXXXXXXXXXXXXX#######XXoooo  .  .",
-" #OOOOOOOO###@@@@@@@@@#OOOOOOO#ooooooooooooooooooooXXXooo     . ",
-" #OOOOOOOOO###@@@@@@@@@#OOOOOOO##XXXXXXXXXXXXXXXXXooooo      .  ",
-"  #OOOOOOOOO#@@@@@@@@###OOOOOOOOO#XXXXXXXXXXXXXXXoo      oooooo ",
-"  #OOOOOOOOO#@@@@@@@####OOOOOOOO#@@@@@@@@@@@XXXXXoo   ooooo...o ",
-" #OOOOOOOOOOO###########OOOOOO##XXXXXXXXXXXXXXXXoo   ooXXXoo..o ",
-"  ##OOOOOOOOO###########OOOO##@@@@@@@@@@@@@XXXXoo    oXXXXX..o  ",
-"     ###OOOO###    oXX##OOO#XXXXXXXXXXXXXXXXXXoo     o.....oo   ",
-"         ####      oooo####oooooooooooooooooooo      ooooooo    ",
-"                                                                ",
-"                                                                "};
_

Patches currently in -mm which might be from rpjday@mindspring.com are

h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable.patch
git-dvb.patch
git-kvm.patch
git-mtd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
m68knommu-remove-unused-config-symbol-config_disktel.patch
m32r-serial-remove-m32r_sio_share_irqs.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
kconfig-make-instrumentation-support-non-experimental.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
remove-valueless-definition-of-hard-selected-ramfs-option.patch
remove-final-traces-of-long-deprecated-ramdisk-kernel.patch
add-a-rounddown_pow_of_two-routine-to-log2h.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
ipc-namespace-remove-config-ipc-ns-fix.patch
documentation-delete-unreferenced-xterm-linuxxpm-file.patch
