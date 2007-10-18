From: akpm@linux-foundation.org
Subject: - documentation-delete-unreferenced-xterm-linuxxpm-file.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:28 -0700
Message-ID: <200710180704.l9I74SAV031553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48914 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763007AbXJRHPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Documentation: delete unreferenced xterm-linux.xpm file
has been removed from the -mm tree.  Its filename was
     documentation-delete-unreferenced-xterm-linuxxpm-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -414,7 +414,5 @@ watchdog/
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

origin.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
