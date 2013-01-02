From: akpm@linux-foundation.org
Subject: [folded-merged] mutex-subsystem-synchro-test-module-fix.patch removed from -mm tree
Date: Wed, 02 Jan 2013 14:36:48 -0800
Message-ID: <20130102223648.7A57D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:41398 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3ABWgt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 17:36:49 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so1554749ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 14:36:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bunk@stusta.de, dhowells@redhat.com, mingo@elte.hu, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mutex-subsystem-synchro-test-module-fix
has been removed from the -mm tree.  Its filename was
     mutex-subsystem-synchro-test-module-fix.patch

This patch was dropped because it was folded into mutex-subsystem-synchro-test-module.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mutex-subsystem-synchro-test-module-fix

remove smp_lock.h inclusion

Cc: Adrian Bunk <bunk@stusta.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/synchro-test.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/synchro-test.c~mutex-subsystem-synchro-test-module-fix kernel/synchro-test.c
--- a/kernel/synchro-test.c~mutex-subsystem-synchro-test-module-fix
+++ a/kernel/synchro-test.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <asm/atomic.h>
 #include <linux/personality.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/timer.h>
 #include <linux/completion.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
rtc-add-rtc-driver-for-tps6586x-fix.patch
linux-next.patch
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

