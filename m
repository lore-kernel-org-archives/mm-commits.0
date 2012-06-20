From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch added to -mm tree
Date: Wed, 20 Jun 2012 14:20:06 -0700
Message-ID: <20120620212006.C9B8BA0123@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:48309 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab2FTVUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 17:20:08 -0400
Received: by qcsp5 with SMTP id p5so767167qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 14:20:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rdunlap@xenotime.net


The patch titled
     Subject: lib/vsprintf.c: remind people to update Documentation/printk-formats.txt when adding printk formats
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/vsprintf.c: remind people to update Documentation/printk-formats.txt when adding printk formats

Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/vsprintf.c~lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats
+++ a/lib/vsprintf.c
@@ -1297,6 +1297,8 @@ qualifier:
  *   case.
  * %n is ignored
  *
+ * ** Please update Documentation/printk-formats.txt when making changes **
+ *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing
  * '\0', as per ISO C99. If you want to have the exact
_
Subject: Subject: lib/vsprintf.c: remind people to update Documentation/printk-formats.txt when adding printk formats

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
mm-fix-slab-page-_count-corruption-when-using-slub.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
backlight-l4f00242t03-use-devm_gpio_request_one-fix.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

