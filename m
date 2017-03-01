From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch added to -mm tree
Date: Tue, 28 Feb 2017 16:06:33 -0800
Message-ID: <58b61089.oPA9V3zuNabXOSMh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35556 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751511AbdCACBJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 21:01:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org, william.c.roberts@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix
has been added to the -mm tree.  Its filename is
     checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%25pfoo-extensions-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%25pfoo-extensions-fix.patch

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
Subject: checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix

add helpful comment into lib/vsprintf.c

Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: William Roberts <william.c.roberts@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/vsprintf.c~checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix lib/vsprintf.c
--- a/lib/vsprintf.c~checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix
+++ a/lib/vsprintf.c
@@ -1477,6 +1477,9 @@ int kptr_restrict __read_mostly;
  * by an extra set of alphanumeric characters that are extended format
  * specifiers.
  *
+ * Please update scripts/checkpatch.pl when adding new conversion characters.
+ * (search for "check for vsprintf extension").
+ *
  * Right now we handle:
  *
  * - 'F' For symbolic function descriptor pointers with offset
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

