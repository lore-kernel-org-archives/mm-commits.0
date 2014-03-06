From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-mauro-and-borislav-as-interim-patch-collectors.patch
 removed from -mm tree
Date: Thu, 06 Mar 2014 12:37:20 -0800
Message-ID: <5318dc80.FeEz+0CypM6kYo3j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaCFUhV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 15:37:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, m.chehab@samsung.com, dougthompson@xmission.com, bp@suse.de

Subject: [merged] maintainers-add-mauro-and-borislav-as-interim-patch-collectors.patch removed from -mm tree
To: bp@suse.de,dougthompson@xmission.com,m.chehab@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 12:37:20 -0800


The patch titled
     Subject: MAINTAINERS: EDAC: add Mauro and Borislav as interim patch collectors
has been removed from the -mm tree.  Its filename was
     maintainers-add-mauro-and-borislav-as-interim-patch-collectors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: MAINTAINERS: EDAC: add Mauro and Borislav as interim patch collectors

We're more or less collecting EDAC patches already anyway so let's hold it
down so that get_maintainer sees it too.

Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-mauro-and-borislav-as-interim-patch-collectors MAINTAINERS
--- a/MAINTAINERS~maintainers-add-mauro-and-borislav-as-interim-patch-collectors
+++ a/MAINTAINERS
@@ -3095,6 +3095,8 @@ F:	fs/ecryptfs/
 
 EDAC-CORE
 M:	Doug Thompson <dougthompson@xmission.com>
+M:	Borislav Petkov <bp@alien8.de>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Supported
_

Patches currently in -mm which might be from bp@suse.de are

origin.patch
tools-vm-page-typesc-page-cache-sniffing-feature.patch
submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch
submittingpatches-add-recommendation-for-mailing-list-references.patch
submittingpatches-document-the-use-of-git.patch
linux-next.patch

