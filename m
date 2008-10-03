From: akpm@linux-foundation.org
Subject: + submitchecklist-interfaces-changes-should-cc-linux-api.patch added to -mm tree
Date: Thu, 02 Oct 2008 22:57:07 -0700
Message-ID: <200810030557.m935v7nf013388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398AbYJCF5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 01:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mtk.manpages@googlemail.com, mtk.manpages@gmail.com


The patch titled
     SubmitChecklist: interfaces changes should CC linux-api@
has been added to the -mm tree.  Its filename is
     submitchecklist-interfaces-changes-should-cc-linux-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

maintainers-add-mailing-list-for-man-pages.patch
submitchecklist-interfaces-changes-should-cc-linux-api.patch
git-block.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch

