From: akpm@linux-foundation.org
Subject: + maintainers-update-matroxfb-ncpfs-status.patch added to -mm tree
Date: Mon, 27 Sep 2010 14:06:59 -0700
Message-ID: <201009272106.o8RL6xqq016665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180Ab0I0VHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 17:07:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: petr@vandrovec.name


The patch titled
     MAINTAINERS: update matroxfb & ncpfs status
has been added to the -mm tree.  Its filename is
     maintainers-update-matroxfb-ncpfs-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update matroxfb & ncpfs status
From: Petr Vandrovec <petr@vandrovec.name>

I moved couple years ago, so let's update my email and snail mail.

And I do not have any access to Matrox hardware anymore, and I'm quite
unresponsive to matroxfb bug reports (sorry Alan), so saying that I'm
maintainer is a bit far fetched.

For ncpfs I do not use ncpfs in my daily life either, but at least I can
test that one, so I can stay listed here for odd fixes.

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    8 ++++----
 MAINTAINERS |    7 +++----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff -puN CREDITS~maintainers-update-matroxfb-ncpfs-status CREDITS
--- a/CREDITS~maintainers-update-matroxfb-ncpfs-status
+++ a/CREDITS
@@ -3554,12 +3554,12 @@ E: cvance@nai.com
 D: portions of the Linux Security Module (LSM) framework and security modules
 
 N: Petr Vandrovec
-E: vandrove@vc.cvut.cz
+E: petr@vandrovec.name
 D: Small contributions to ncpfs
 D: Matrox framebuffer driver
-S: Chudenicka 8
-S: 10200 Prague 10, Hostivar
-S: Czech Republic
+S: 21513 Conradia Ct
+S: Cupertino, CA 95014
+S: USA
 
 N: Thibaut Varene
 E: T-Bone@parisc-linux.org
diff -puN MAINTAINERS~maintainers-update-matroxfb-ncpfs-status MAINTAINERS
--- a/MAINTAINERS~maintainers-update-matroxfb-ncpfs-status
+++ a/MAINTAINERS
@@ -3839,9 +3839,8 @@ W:	http://www.syskonnect.com
 S:	Supported
 
 MATROX FRAMEBUFFER DRIVER
-M:	Petr Vandrovec <vandrove@vc.cvut.cz>
 L:	linux-fbdev@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/video/matrox/matroxfb_*
 F:	include/linux/matroxfb.h
 
@@ -4028,8 +4027,8 @@ S:	Maintained
 F:	drivers/net/natsemi.c
 
 NCP FILESYSTEM
-M:	Petr Vandrovec <vandrove@vc.cvut.cz>
-S:	Maintained
+M:	Petr Vandrovec <petr@vandrovec.name>
+S:	Odd Fixes
 F:	fs/ncpfs/
 
 NCR DUAL 700 SCSI DRIVER (MICROCHANNEL)
_

Patches currently in -mm which might be from petr@vandrovec.name are

maintainers-update-matroxfb-ncpfs-status.patch

