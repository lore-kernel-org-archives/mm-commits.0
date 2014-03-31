From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-restore-randy-as-documentation-maintainer.patch removed from
 -mm tree
Date: Mon, 31 Mar 2014 11:21:21 -0700
Message-ID: <5339b221.ZyyY2F2kqAc2NFFV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbaCaSVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Mar 2014 14:21:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, rdunlap@infradead.org

Subject: [merged] maintainers-restore-randy-as-documentation-maintainer.patch removed from -mm tree
To: rdunlap@infradead.org,rob@landley.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 31 Mar 2014 11:21:21 -0700


The patch titled
     Subject: MAINTAINERS: restore Randy as Documentation maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-restore-randy-as-documentation-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
idr-remove-dead-code-v2.patch
include-asm-generic-bugh-style-fix-s-while0-while-0.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

