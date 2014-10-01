From: akpm@linux-foundation.org
Subject: + maintainers-orphan-m32r.patch added to -mm tree
Date: Wed, 01 Oct 2014 15:37:08 -0700
Message-ID: <542c8214.L4PhgaLQM7O2PK2o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaJAWhK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 18:37:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.opdenacker@free-electrons.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: orphan m32r
has been added to the -mm tree.  Its filename is
     maintainers-orphan-m32r.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-orphan-m32r.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-orphan-m32r.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5658,11 +5658,8 @@ T:	git git://github.com/linux-test-proje
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

score-remove-deprecated-irqf_disabled.patch
frv-remove-deprecated-irqf_disabled.patch
maintainers-orphan-m32r.patch
linux-next.patch

