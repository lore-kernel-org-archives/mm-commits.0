From: akpm@linux-foundation.org
Subject: [merged]
 documentation-filesystems-sysfstxt-fix-device_attribute-declaration.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:03:14 -0800
Message-ID: <52e2b8f2.+Jygn4KE+4fOfZJ+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43806 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaAXTDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:03:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, greg@kroah.com, andre.o.richter@gmail.com

Subject: [merged] documentation-filesystems-sysfstxt-fix-device_attribute-declaration.patch removed from -mm tree
To: andre.o.richter@gmail.com,greg@kroah.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:03:14 -0800


The patch titled
     Subject: Documentation/filesystems/sysfs.txt: fix device_attribute declaration
has been removed from the -mm tree.  Its filename was
     documentation-filesystems-sysfstxt-fix-device_attribute-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

