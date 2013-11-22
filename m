From: akpm@linux-foundation.org
Subject: +
 documentation-filesystems-sysfstxt-fix-device_attribute-declaration.patch
 added to -mm tree
Date: Thu, 21 Nov 2013 16:46:38 -0800
Message-ID: <528ea96e.Xs2jq78tkOL42/Jb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab3KVAqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Nov 2013 19:46:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, greg@kroah.com, andre.o.richter@gmail.com

Subject: + documentation-filesystems-sysfstxt-fix-device_attribute-declaration.patch added to -mm tree
To: andre.o.richter@gmail.com,greg@kroah.com
From: akpm@linux-foundation.org
Date: Thu, 21 Nov 2013 16:46:38 -0800


The patch titled
     Subject: Documentation/filesystems/sysfs.txt: fix device_attribute declaration
has been added to the -mm tree.  Its filename is
     documentation-filesystems-sysfstxt-fix-device_attribute-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-filesystems-sysfstxt-fix-device_attribute-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-filesystems-sysfstxt-fix-device_attribute-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andre Richter <andre.o.richter@gmail.com>
Subject: Documentation/filesystems/sysfs.txt: fix device_attribute declaration

Fix a wrong device_attribute declaration example.

Signed-off-by: Andre Richter <andre.o.richter@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/sysfs.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/sysfs.txt~documentation-filesystems-sysfstxt-fix-device_attribute-declaration Documentation/filesystems/sysfs.txt
--- a/Documentation/filesystems/sysfs.txt~documentation-filesystems-sysfstxt-fix-device_attribute-declaration
+++ a/Documentation/filesystems/sysfs.txt
@@ -108,12 +108,12 @@ static DEVICE_ATTR(foo, S_IWUSR | S_IRUG
 is equivalent to doing:
 
 static struct device_attribute dev_attr_foo = {
-       .attr	= {
+	.attr = {
 		.name = "foo",
 		.mode = S_IWUSR | S_IRUGO,
-		.show = show_foo,
-		.store = store_foo,
 	},
+	.show = show_foo,
+	.store = store_foo,
 };
 
 
_

Patches currently in -mm which might be from andre.o.richter@gmail.com are

origin.patch
documentation-filesystems-sysfstxt-fix-device_attribute-declaration.patch

