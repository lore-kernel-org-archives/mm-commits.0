From: akpm@linux-foundation.org
Subject: + maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries.patch added to -mm tree
Date: Thu, 24 Feb 2011 14:33:47 -0800
Message-ID: <201102242233.p1OMXlO1030723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756169Ab1BXWdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 17:33:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, harryxiyou@gmail.com


The patch titled
     MAINTAINERS: remove unnecessary linux-kernel@vger.kernel.org entries
has been added to the -mm tree.  Its filename is
     maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries.patch

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
Subject: MAINTAINERS: remove unnecessary linux-kernel@vger.kernel.org entries
From: Joe Perches <joe@perches.com>

CC'ing lkml is the default and doesn't need separate entries.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 -----
 1 file changed, 5 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries
+++ a/MAINTAINERS
@@ -2799,7 +2799,6 @@ F:	include/linux/gigaset_dev.h
 
 GPIO SUBSYSTEM
 M:	Grant Likely <grant.likely@secretlab.ca>
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.secretlab.ca/git/linux-2.6.git
 F:	Documentation/gpio/gpio.txt
@@ -2822,7 +2821,6 @@ F:	drivers/platform/x86/hdaps.c
 HWPOISON MEMORY FAILURE HANDLING
 M:	Andi Kleen <andi@firstfloor.org>
 L:	linux-mm@kvack.org
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison
 S:	Maintained
 F:	mm/memory-failure.c
@@ -4699,7 +4697,6 @@ F:	drivers/i2c/busses/i2c-pasemi.c
 
 PADATA PARALLEL EXECUTION MECHANISM
 M:	Steffen Klassert <steffen.klassert@secunet.com>
-L:	linux-kernel@vger.kernel.org
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	kernel/padata.c
@@ -4849,7 +4846,6 @@ F:	include/crypto/pcrypt.h
 PER-CPU MEMORY ALLOCATOR
 M:	Tejun Heo <tj@kernel.org>
 M:	Christoph Lameter <cl@linux-foundation.org>
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git
 S:	Maintained
 F:	include/linux/percpu*.h
@@ -6900,7 +6896,6 @@ F:	sound/soc/codecs/wm*
 
 WORKQUEUE
 M:	Tejun Heo <tj@kernel.org>
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git
 S:	Maintained
 F:	include/linux/workqueue.h
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-add-chinese-documentation-maintainer.patch
vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space.patch
printk-allow-setting-default_message_level-via-kconfig.patch
get_maintainerpl-allow-k-pattern-tests-to-match-non-patch-text.patch
maintainers-quote-non-alphanumeric-email-addresses.patch
maintainers-update-adp5520-pattern.patch
maintainers-change-web-links-from-wiki-analog-to-wikianalog.patch
maintainers-remove-asoc-codec-drivers-files-not-in-tree.patch
maintainers-add-missing-after-hr-timers-f-tag.patch
maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries.patch
maintainers-update-clkdev-location.patch
maintainers-update-media-path.patch
maintainers-update-hvc-file-patterns.patch
maintainers-remove-unused-clockeventsh.patch
maintainers-remove-ieee1394-entry.patch
maintainers-remove-unused-timekeeping-timekeepingh.patch
maintainers-update-scx200-file-pattern.patch
maintainers-remove-sharp-lh7a40x-section.patch
maintainers-update-sfi-pattern.patch
maintainers-update-tipc-patterns.patch
maintainers-usb-se401-moved-to-staging-update-pattern.patch
maintainers-update-winbond-cir-pattern.patch

