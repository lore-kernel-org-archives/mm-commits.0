From: akpm@linux-foundation.org
Subject: + maintainers-use-tab-not-spaces-for-delimiter.patch added to -mm tree
Date: Thu, 18 Mar 2010 16:18:05 -0700
Message-ID: <201003182318.o2INI52d021506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968Ab0CRXSl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 19:18:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: use tab not spaces for delimiter
has been added to the -mm tree.  Its filename is
     maintainers-use-tab-not-spaces-for-delimiter.patch

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
Subject: MAINTAINERS: use tab not spaces for delimiter
From: Joe Perches <joe@perches.com>

Keeps MAINTAINERS a bit more consistent.
done via sed -r -i -e 's/^([A-Z]):[ \t]+/\1:\t/g' MAINTAINERS

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff -puN MAINTAINERS~maintainers-use-tab-not-spaces-for-delimiter MAINTAINERS
--- a/MAINTAINERS~maintainers-use-tab-not-spaces-for-delimiter
+++ a/MAINTAINERS
@@ -797,12 +797,12 @@ M:	Michael Petchkovsky <mkpetch@internod
 S:	Maintained
 
 ARM/NOMADIK ARCHITECTURE
-M:     Alessandro Rubini <rubini@unipv.it>
-M:     STEricsson <STEricsson_nomadik_linux@list.st.com>
-L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:     Maintained
-F:     arch/arm/mach-nomadik/
-F:     arch/arm/plat-nomadik/
+M:	Alessandro Rubini <rubini@unipv.it>
+M:	STEricsson <STEricsson_nomadik_linux@list.st.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/arm/mach-nomadik/
+F:	arch/arm/plat-nomadik/
 
 ARM/OPENMOKO NEO FREERUNNER (GTA02) MACHINE SUPPORT
 M:	Nelson Castillo <arhuaco@freaks-unidos.net>
@@ -1927,17 +1927,17 @@ F:	drivers/scsi/dpt*
 F:	drivers/scsi/dpt/
 
 DRBD DRIVER
-P:     Philipp Reisner
-P:     Lars Ellenberg
-M:     drbd-dev@lists.linbit.com
-L:     drbd-user@lists.linbit.com
-W:     http://www.drbd.org
-T:     git git://git.drbd.org/linux-2.6-drbd.git drbd
-T:     git git://git.drbd.org/drbd-8.3.git
-S:     Supported
-F:     drivers/block/drbd/
-F:     lib/lru_cache.c
-F:     Documentation/blockdev/drbd/
+P:	Philipp Reisner
+P:	Lars Ellenberg
+M:	drbd-dev@lists.linbit.com
+L:	drbd-user@lists.linbit.com
+W:	http://www.drbd.org
+T:	git git://git.drbd.org/linux-2.6-drbd.git drbd
+T:	git git://git.drbd.org/drbd-8.3.git
+S:	Supported
+F:	drivers/block/drbd/
+F:	lib/lru_cache.c
+F:	Documentation/blockdev/drbd/
 
 DRIVER CORE, KOBJECTS, AND SYSFS
 M:	Greg Kroah-Hartman <gregkh@suse.de>
@@ -3539,8 +3539,8 @@ F:	drivers/scsi/sym53c8xx_2/
 LTP (Linux Test Project)
 M:	Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
 M:	Garrett Cooper <yanegomi@gmail.com>
-M:     Mike Frysinger <vapier@gentoo.org>
-M:     Subrata Modak <subrata@linux.vnet.ibm.com>
+M:	Mike Frysinger <vapier@gentoo.org>
+M:	Subrata Modak <subrata@linux.vnet.ibm.com>
 L:	ltp-list@lists.sourceforge.net (subscribers-only)
 W:	http://ltp.sourceforge.net/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
@@ -6247,7 +6247,7 @@ F:	arch/x86/
 X86 PLATFORM DRIVERS
 M:	Matthew Garrett <mjg@redhat.com>
 L:	platform-driver-x86@vger.kernel.org
-T:      git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git
 S:	Maintained
 F:	drivers/platform/x86
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
get_maintainer-repair-stdin-usage.patch
maintainers-use-tab-not-spaces-for-delimiter.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

