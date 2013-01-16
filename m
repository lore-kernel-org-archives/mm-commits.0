From: akpm@linux-foundation.org
Subject: + maintainers-mm-add-additional-include-files-to-listing.patch added to -mm tree
Date: Wed, 16 Jan 2013 14:57:26 -0800
Message-ID: <20130116225726.8FEB531C1B2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:50081 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab3APW51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 17:57:27 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so233808ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 14:57:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com


The patch titled
     Subject: MAINTAINERS: mm: add additional include files to listing
has been added to the -mm tree.  Its filename is
     maintainers-mm-add-additional-include-files-to-listing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: MAINTAINERS: mm: add additional include files to listing

Add gfp.h, mmzone.h, memory_hotplug.h & vmalloc.h to the "MEMORY
MANAGMENT" section so scripts/get_maintainer.pl can do a better job of
making recommendations.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN MAINTAINERS~maintainers-mm-add-additional-include-files-to-listing MAINTAINERS
--- a/MAINTAINERS~maintainers-mm-add-additional-include-files-to-listing
+++ a/MAINTAINERS
@@ -5127,6 +5127,10 @@ L:	linux-mm@kvack.org
 W:	http://www.linux-mm.org
 S:	Maintained
 F:	include/linux/mm.h
+F:	include/linux/gfp.h
+F:	include/linux/mmzone.h
+F:	include/linux/memory_hotplug.h
+F:	include/linux/vmalloc.h
 F:	mm/
 
 MEMORY RESOURCE CONTROLLER
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

linux-next.patch
maintainers-mm-add-additional-include-files-to-listing.patch

