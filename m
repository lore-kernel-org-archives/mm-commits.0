From: akpm@linux-foundation.org
Subject: + maintainers-blackfin-add-git-repository.patch added to -mm tree
Date: Wed, 05 Mar 2014 12:43:01 -0800
Message-ID: <53178c55.KpUvE6jwrvn9ztUN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbaCEUnC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2014 15:43:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, realmz6@gmail.com, michael.opdenacker@free-electrons.com

Subject: + maintainers-blackfin-add-git-repository.patch added to -mm tree
To: michael.opdenacker@free-electrons.com,realmz6@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 05 Mar 2014 12:43:01 -0800


The patch titled
     Subject: MAINTAINERS: blackfin: add git repository
has been added to the -mm tree.  Its filename is
     maintainers-blackfin-add-git-repository.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-blackfin-add-git-repository.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-blackfin-add-git-repository.patch

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
Subject: MAINTAINERS: blackfin: add git repository

Add the git repository currently in use for blackfin architecture
development.

This information was obtained from Steven Miao.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-blackfin-add-git-repository MAINTAINERS
--- a/MAINTAINERS~maintainers-blackfin-add-git-repository
+++ a/MAINTAINERS
@@ -1738,6 +1738,7 @@ F:	include/uapi/linux/bfs_fs.h
 BLACKFIN ARCHITECTURE
 M:	Steven Miao <realmz6@gmail.com>
 L:	adi-buildroot-devel@lists.sourceforge.net
+T:	git git://git.code.sf.net/p/adi-linux/code
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	arch/blackfin/
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

maintainers-blackfin-add-git-repository.patch
linux-next.patch

