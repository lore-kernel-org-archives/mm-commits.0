From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch
 added to -mm tree
Date: Wed, 27 Sep 2017 15:41:57 -0700
Message-ID: <59cc2935.pVXLEY2PBEKWyue2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55914 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbdI0Wl7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 18:41:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, colin.king@canonical.com, joe@perches.com, keescook@chromium.org, ross.zwisler@linux.intel.com, sboyd@codeaurora.org, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch

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
Subject: scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix

s/|/||/, per Joe

Cc: Colin Ian King <colin.king@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/spelling.txt~scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix
+++ a/scripts/spelling.txt
@@ -492,7 +492,7 @@ failied||failed
 faillure||failure
 failue||failure
 failuer||failure
-failng|failing
+failng||failing
 faireness||fairness
 falied||failed
 faliure||failure
@@ -1118,7 +1118,7 @@ swithced||switched
 swithcing||switching
 swithed||switched
 swithing||switching
-swtich|switch
+swtich||switch
 symetric||symmetric
 synax||syntax
 synchonized||synchronized
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

