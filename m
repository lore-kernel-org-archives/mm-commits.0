From: akpm@linux-foundation.org
Subject: [folded-merged]
 checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch removed from -mm tree
Date: Mon, 08 May 2017 15:38:32 -0700
Message-ID: <5910f368.KS0eCtPB1LtMhmbC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40436 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdEHWid (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:38:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org, william.c.roberts@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix
has been removed from the -mm tree.  Its filename was
     checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch

This patch was dropped because it was folded into checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions.patch

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

checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
dax-add-tracepoint-to-dax_writeback_one-fix.patch
drivers-staging-ccree-ssi_hashc-fix-build-with-gcc-444.patch

