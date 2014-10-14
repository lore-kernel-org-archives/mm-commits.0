From: akpm@linux-foundation.org
Subject: [merged] maintainers-orphan-m32r.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:19 -0700
Message-ID: <543d6927.ruhx9FZQcBlFkgw6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbaJNSTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.opdenacker@free-electrons.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: orphan m32r
has been removed from the -mm tree.  Its filename was
     maintainers-orphan-m32r.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: MAINTAINERS: orphan m32r

Update the maintenance status for m32r

- Removing Hirokazu Takata as maintainer
  (last commit merged: Nov. 2009)

- Remove mailing lists that no longer exist,
  as the ml.linux-m32r.org subdomain no longer exists.

- Maintenance status moved to "Orphan"

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Acked-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-orphan-m32r MAINTAINERS
--- a/MAINTAINERS~maintainers-orphan-m32r
+++ a/MAINTAINERS
@@ -5759,11 +5759,8 @@ T:	git git://github.com/linux-test-proje
 S:	Maintained
 
 M32R ARCHITECTURE
-M:	Hirokazu Takata <takata@linux-m32r.org>
-L:	linux-m32r@ml.linux-m32r.org (moderated for non-subscribers)
-L:	linux-m32r-ja@ml.linux-m32r.org (in Japanese)
 W:	http://www.linux-m32r.org/
-S:	Maintained
+S:	Orphan
 F:	arch/m32r/
 
 M68K ARCHITECTURE
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

origin.patch
linux-next.patch

