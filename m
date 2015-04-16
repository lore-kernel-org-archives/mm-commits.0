From: akpm@linux-foundation.org
Subject: [folded-merged]
 doc-sysctl-kerneltxt-document-threads-max-fix.patch removed from -mm tree
Date: Thu, 16 Apr 2015 12:09:26 -0700
Message-ID: <553008e6./vicl66TnYEZkz3n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbDPTJ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:09:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@roeck-us.net, mingo@kernel.org, oleg@redhat.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: doc-sysctl-kerneltxt-document-threads-max-fix
has been removed from the -mm tree.  Its filename was
     doc-sysctl-kerneltxt-document-threads-max-fix.patch

This patch was dropped because it was folded into doc-sysctl-kerneltxt-document-threads-max.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: doc-sysctl-kerneltxt-document-threads-max-fix

fix typo, per Guenter

Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/kernel.txt~doc-sysctl-kerneltxt-document-threads-max-fix Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~doc-sysctl-kerneltxt-document-threads-max-fix
+++ a/Documentation/sysctl/kernel.txt
@@ -882,7 +882,7 @@ maximum number of threads is created, th
 a part (1/8th) of the available RAM pages.
 
 The minimum value that can be written to threads-max is 20.
-The maximum vlaue that can be written to threads-max is given by the
+The maximum value that can be written to threads-max is given by the
 constant FUTEX_TID_MASK (0x3fffffff).
 If a value outside of this range is written to threads-max an error
 EINVAL occurs.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-find__bit-reimplementation.patch
checkpatch-match-more-world-writable-permissions.patch
binfmt_misc-simplify-entry_status.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc.patch
fs-fat-remove-unnecessary-includes.patch
kernel-forkc-avoid-division-by-zero.patch
doc-sysctl-kerneltxt-document-threads-max.patch
mm-rcu-protected-get_mm_exe_file.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch

