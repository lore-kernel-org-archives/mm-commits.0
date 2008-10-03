From: akpm@linux-foundation.org
Subject: + documentation-howto-info-about-interface-changes-should-cc-linux-api-vger.patch added to -mm tree
Date: Thu, 02 Oct 2008 22:57:53 -0700
Message-ID: <200810030557.m935vrg2013391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbYJCF6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 01:58:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mtk.manpages@googlemail.com, mtk.manpages@gmail.com


The patch titled
     Documentation/HOWTO: info about interface changes should CC linux-api@vger
has been added to the -mm tree.  Its filename is
     documentation-howto-info-about-interface-changes-should-cc-linux-api-vger.patch

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
Subject: Documentation/HOWTO: info about interface changes should CC linux-api@vger
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>

The "Documentation" section of this file mentions that when an interface
change is made, I should be CCed with info about the change (so that
man-pages can document it).  Additionally request that this info be CCed
to the new linux-api@vger.kernel.org list.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/HOWTO |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/HOWTO~documentation-howto-info-about-interface-changes-should-cc-linux-api-vger Documentation/HOWTO
--- a/Documentation/HOWTO~documentation-howto-info-about-interface-changes-should-cc-linux-api-vger
+++ a/Documentation/HOWTO
@@ -77,7 +77,8 @@ documentation files are also added which
 When a kernel change causes the interface that the kernel exposes to
 userspace to change, it is recommended that you send the information or
 a patch to the manual pages explaining the change to the manual pages
-maintainer at mtk.manpages@gmail.com.
+maintainer at mtk.manpages@gmail.com, and CC the list
+linux-api@vger.kernel.org.
 
 Here is a list of files that are in the kernel source tree that are
 required reading:
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

maintainers-add-mailing-list-for-man-pages.patch
submitchecklist-interfaces-changes-should-cc-linux-api.patch
documentation-howto-info-about-interface-changes-should-cc-linux-api-vger.patch
git-block.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch

