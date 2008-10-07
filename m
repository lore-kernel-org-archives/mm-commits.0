From: akpm@linux-foundation.org
Subject: - submitchecklist-interfaces-changes-should-cc-linux-api.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:39:19 -0700
Message-ID: <200810072339.m97NdJ9o009544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486AbYJGXjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:39:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@googlemail.com, mtk.manpages@gmail.com, mm-commits@vger.kernel.org


The patch titled
     SubmitChecklist: interfaces changes should CC linux-api@
has been removed from the -mm tree.  Its filename was
     submitchecklist-interfaces-changes-should-cc-linux-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SubmitChecklist: interfaces changes should CC linux-api@
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>

Mention that patches that change the kernel-userland interface should
be CCed to the new list linux-api@vger.kernel.org.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/SubmitChecklist~submitchecklist-interfaces-changes-should-cc-linux-api Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~submitchecklist-interfaces-changes-should-cc-linux-api
+++ a/Documentation/SubmitChecklist
@@ -67,6 +67,8 @@ kernel patches.
 
 19: All new userspace interfaces are documented in Documentation/ABI/.
     See Documentation/ABI/README for more information.
+    Patches that change userspace interfaces should be CCed to
+    linux-api@vger.kernel.org.
 
 20: Check that it all passes `make headers_check'.
 
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

git-tip.patch
git-block.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch

