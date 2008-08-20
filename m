From: akpm@linux-foundation.org
Subject: + mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch added to -mm tree
Date: Tue, 19 Aug 2008 17:11:54 -0700
Message-ID: <200808200011.m7K0Bssj014506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377AbYHTANX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 20:13:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, sameo@openedhand.com


The patch titled
     mfd/ucb1400 sound driver uses/depends on AC97_BUS
has been added to the -mm tree.  Its filename is
     mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd/ucb1400 sound driver uses/depends on AC97_BUS
From: Randy Dunlap <randy.dunlap@oracle.com>

mfd/ucb1400 sound driver uses/depends on AC97_BUS:

ERROR: "ac97_bus_type" [drivers/mfd/ucb1400_core.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mfd/Kconfig~mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus
+++ a/drivers/mfd/Kconfig
@@ -52,6 +52,7 @@ config HTC_PASIC3
 
 config UCB1400_CORE
 	tristate "Philips UCB1400 Core driver"
+	depends on AC97_BUS
 	help
 	  This enables support for the Philips UCB1400 core functions.
 	  The UCB1400 is an AC97 audio codec.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

documentation-describe-bootmem_debug-kernel-parameter.patch
linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

