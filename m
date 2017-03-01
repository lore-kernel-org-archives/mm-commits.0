From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch added to -mm tree
Date: Tue, 28 Feb 2017 16:16:46 -0800
Message-ID: <58b612ee.B2Yweg905+5Zgi2h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40396 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdCAAnJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 19:43:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org, william.c.roberts@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix
has been added to the -mm tree.  Its filename is
     checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%25pfoo-extensions-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%25pfoo-extensions-fix-fix.patch

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
Subject: checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix

text tweak

Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: William Roberts <william.c.roberts@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/vsprintf.c~checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix lib/vsprintf.c
--- a/lib/vsprintf.c~checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix
+++ a/lib/vsprintf.c
@@ -1477,8 +1477,8 @@ int kptr_restrict __read_mostly;
  * by an extra set of alphanumeric characters that are extended format
  * specifiers.
  *
- * Please update scripts/checkpatch.pl when adding new conversion characters.
- * (search for "check for vsprintf extension").
+ * Please update scripts/checkpatch.pl when adding/removing conversion
+ * characters.  (Search for "check for vsprintf extension").
  *
  * Right now we handle:
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

