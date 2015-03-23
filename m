From: akpm@linux-foundation.org
Subject: + maintainers-remove-drm-drivers-for-renesas-pattern.patch added
 to -mm tree
Date: Mon, 23 Mar 2015 15:16:19 -0700
Message-ID: <551090b3.lbKPpCdjw8HK57Up%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbbCWWQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Mar 2015 18:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, laurent.pinchart@ideasonboard.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Remove  DRM DRIVERS FOR RENESAS pattern
has been added to the -mm tree.  Its filename is
     maintainers-remove-drm-drivers-for-renesas-pattern.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-drm-drivers-for-renesas-pattern.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-drm-drivers-for-renesas-pattern.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: Remove  DRM DRIVERS FOR RENESAS pattern

commit 2378ad1228d2 ("drm: rcar-du: Remove platform data support")
removed the file, remove the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-drm-drivers-for-renesas-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-drm-drivers-for-renesas-pattern
+++ a/MAINTAINERS
@@ -3405,7 +3405,6 @@ T:	git git://people.freedesktop.org/~air
 S:	Supported
 F:	drivers/gpu/drm/rcar-du/
 F:	drivers/gpu/drm/shmobile/
-F:	include/linux/platform_data/rcar-du.h
 F:	include/linux/platform_data/shmob_drm.h
 
 DSBR100 USB FM RADIO DRIVER
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-correct-rtc-armada38x-pattern-entry.patch
maintainers-remove-drm-drivers-for-renesas-pattern.patch
hfsplus-fix-b-tree-corruption-after-insertion-at-position-0.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
linux-next.patch

