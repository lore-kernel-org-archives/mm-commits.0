From: akpm@linux-foundation.org
Subject: + documentation-vm-page_migration-update-reference-to-numa_maps-fix-download-uri.patch added to -mm tree
Date: Tue, 12 Aug 2008 16:34:03 -0700
Message-ID: <200808122334.m7CNY3Jo019539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbYHLXez (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 19:34:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mtk.manpages@googlemail.com, Lee.Schermerhorn@hp.com, cpw@sgi.com, mtk.manpages@gmail.com, rdunlap@xenotime.net


The patch titled
     Documentation/vm/page_migration: update reference to numa_maps + fix download URI
has been added to the -mm tree.  Its filename is
     documentation-vm-page_migration-update-reference-to-numa_maps-fix-download-uri.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/vm/page_migration: update reference to numa_maps + fix download URI
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>

With man-pages-3.07, the numa_maps documentation home is now proc(5), so
the reference in Documentation/vm/page_migration needs updating. 
(Cliff/Lee are removing numa_maps.5 from the numactl package.) Also, the
download location for the numactl package changed a while back.  This
patch fixes both things, as well as a typo (provided-->provides).

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_migration |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN Documentation/vm/page_migration~documentation-vm-page_migration-update-reference-to-numa_maps-fix-download-uri Documentation/vm/page_migration
--- a/Documentation/vm/page_migration~documentation-vm-page_migration-update-reference-to-numa_maps-fix-download-uri
+++ a/Documentation/vm/page_migration
@@ -18,10 +18,11 @@ migrate_pages function call takes two se
 process that are located on the from nodes to the destination nodes.
 Page migration functions are provided by the numactl package by Andi Kleen
 (a version later than 0.9.3 is required. Get it from
-ftp://ftp.suse.com/pub/people/ak). numactl provided libnuma which
-provides an interface similar to other numa functionality for page migration.
-cat /proc/<pid>/numa_maps allows an easy review of where the pages of
-a process are located. See also the numa_maps manpage in the numactl package.
+ftp://oss.sgi.com/www/projects/libnuma/download/). numactl provides libnuma
+which provides an interface similar to other numa functionality for page
+migration.  cat /proc/<pid>/numa_maps allows an easy review of where the
+pages of a process are located. See also the numa_maps documentation in the
+proc(5) man page.
 
 Manual migration is useful if for example the scheduler has relocated
 a process to a processor on a distant node. A batch scheduler or an
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

documentation-vm-page_migration-update-reference-to-numa_maps-fix-download-uri.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch

