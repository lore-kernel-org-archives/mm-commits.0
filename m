From: akpm@linux-foundation.org
Subject: +
 maintainers-add-mauro-and-borislav-as-interim-patch-collectors.patch added
 to -mm tree
Date: Thu, 13 Feb 2014 13:44:51 -0800
Message-ID: <52fd3cd3.iYuea46WmVB1W1S8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaBMVow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 16:44:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, m.chehab@samsung.com, dougthompson@xmission.com, bp@suse.de

Subject: + maintainers-add-mauro-and-borislav-as-interim-patch-collectors.patch added to -mm tree
To: bp@suse.de,dougthompson@xmission.com,m.chehab@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 13:44:51 -0800


The patch titled
     Subject: MAINTAINERS: add Mauro and Borislav as interim patch collectors
has been added to the -mm tree.  Its filename is
     maintainers-add-mauro-and-borislav-as-interim-patch-collectors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-mauro-and-borislav-as-interim-patch-collectors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-mauro-and-borislav-as-interim-patch-collectors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: MAINTAINERS: add Mauro and Borislav as interim patch collectors

We're more or less collecting EDAC patches already anyway so let's hold it
down so that get_maintainer sees it too.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-mauro-and-borislav-as-interim-patch-collectors MAINTAINERS
--- a/MAINTAINERS~maintainers-add-mauro-and-borislav-as-interim-patch-collectors
+++ a/MAINTAINERS
@@ -3082,6 +3082,8 @@ F:	fs/ecryptfs/
 
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
maintainers-add-mauro-and-borislav-as-interim-patch-collectors.patch
linux-next.patch

