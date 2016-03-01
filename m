From: akpm@linux-foundation.org
Subject: + maintainers-update-tpmdd-urls.patch added to -mm tree
Date: Tue, 01 Mar 2016 14:07:23 -0800
Message-ID: <56d6129b.gzPPB5fsfXLwmv6J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbcCAWHY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 17:07:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update tpmdd urls
has been added to the -mm tree.  Its filename is
     maintainers-update-tpmdd-urls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-tpmdd-urls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-tpmdd-urls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: MAINTAINERS: update tpmdd urls

Updated GIT and patchwork location both of which were out-of-sync or
actually patchwork location was incorrect.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-tpmdd-urls MAINTAINERS
--- a/MAINTAINERS~maintainers-update-tpmdd-urls
+++ a/MAINTAINERS
@@ -11075,8 +11075,8 @@ M:	Jarkko Sakkinen <jarkko.sakkinen@linu
 R:	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
 W:	http://tpmdd.sourceforge.net
 L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
-Q:	git git://github.com/PeterHuewe/linux-tpmdd.git
-T:	git https://github.com/PeterHuewe/linux-tpmdd
+Q:	https://patchwork.kernel.org/project/tpmdd-devel/list/
+T:	git git://git.infradead.org/users/jjs/linux-tpmdd.git
 S:	Maintained
 F:	drivers/char/tpm/
 
_

Patches currently in -mm which might be from jarkko.sakkinen@linux.intel.com are

maintainers-update-tpmdd-urls.patch

