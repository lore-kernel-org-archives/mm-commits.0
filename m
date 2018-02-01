From: akpm@linux-foundation.org
Subject: [folded-merged]
 tools-vm-new-option-to-specify-kpageflags-file-fix-fix.patch removed from
 -mm tree
Date: Wed, 31 Jan 2018 16:07:51 -0800
Message-ID: <5a725a57.4GNXwZly82cGgf03%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58820 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754675AbeBAAHw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:07:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools-vm-new-option-to-specify-kpageflags-file-fix-fix
has been removed from the -mm tree.  Its filename was
     tools-vm-new-option-to-specify-kpageflags-file-fix-fix.patch

This patch was dropped because it was folded into tools-vm-new-option-to-specify-kpageflags-file.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: tools-vm-new-option-to-specify-kpageflags-file-fix-fix

Please find a "fix fix" below per Naoya.  Thanks both!

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1801301840050.140969@chino.kir.corp.google.com
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN tools/vm/page-types.c~tools-vm-new-option-to-specify-kpageflags-file-fix-fix tools/vm/page-types.c
--- a/tools/vm/page-types.c~tools-vm-new-option-to-specify-kpageflags-file-fix-fix
+++ a/tools/vm/page-types.c
@@ -169,10 +169,10 @@ static int		opt_raw;	/* for kernel devel
 static int		opt_list;	/* list pages (in ranges) */
 static int		opt_no_summary;	/* don't show summary */
 static pid_t		opt_pid;	/* process to walk */
-const char *		opt_file;	/* file or directory path */
+const char		*opt_file;	/* file or directory path */
 static uint64_t		opt_cgroup;	/* cgroup inode */
 static int		opt_list_cgroup;/* list page cgroup */
-static const char *	opt_kpageflags;	/* kpageflags file to parse */
+static const char	*opt_kpageflags;/* kpageflags file to parse */
 
 #define MAX_ADDR_RANGES	1024
 static int		nr_addr_ranges;
_

Patches currently in -mm which might be from rientjes@google.com are

mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks.patch
mm-oom-avoid-reaping-only-for-mms-with-blockable-invalidate-callbacks.patch
tools-vm-new-option-to-specify-kpageflags-file.patch

