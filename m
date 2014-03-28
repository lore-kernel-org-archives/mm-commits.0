From: akpm@linux-foundation.org
Subject: + maintainers-restore-randy-as-documentation-maintainer.patch
 added to -mm tree
Date: Fri, 28 Mar 2014 13:47:22 -0700
Message-ID: <5335dfda.y7uFtVcqVM9Y1XeD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaC1UrX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 16:47:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, rdunlap@infradead.org

Subject: + maintainers-restore-randy-as-documentation-maintainer.patch added to -mm tree
To: rdunlap@infradead.org,rob@landley.net
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 13:47:22 -0700


The patch titled
     Subject: MAINTAINERS: restore Randy as Documentation maintainer
has been added to the -mm tree.  Its filename is
     maintainers-restore-randy-as-documentation-maintainer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-restore-randy-as-documentation-maintainer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-restore-randy-as-documentation-maintainer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: restore Randy as Documentation maintainer

I am the new kernel tree Documentation maintainer (except for parts that
are handled by other people, of course).

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-restore-randy-as-documentation-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-restore-randy-as-documentation-maintainer
+++ a/MAINTAINERS
@@ -2828,9 +2828,9 @@ S:	Supported
 F:	drivers/acpi/dock.c
 
 DOCUMENTATION
-M:	Rob Landley <rob@landley.net>
+M:	Randy Dunlap <rdunlap@infradead.org>
 L:	linux-doc@vger.kernel.org
-T:	TBD
+T:	quilt http://www.infradead.org/~rdunlap/Doc/patches/
 S:	Maintained
 F:	Documentation/
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch
submittingpatches-add-recommendation-for-mailing-list-references.patch
submittingpatches-document-the-use-of-git.patch
maintainers-restore-randy-as-documentation-maintainer.patch
idr-remove-dead-code-v2.patch
include-asm-generic-bugh-style-fix-s-while0-while-0.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

