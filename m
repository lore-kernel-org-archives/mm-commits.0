From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-myself-as-gpt-maintainer.patch removed
 from -mm tree
Date: Thu, 19 Dec 2013 11:54:03 -0800
Message-ID: <52b34edb.iqr9OEBpIf9dS6xA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab3LSTyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:54:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, axboe@kernel.dk, Matt_Domsch@dell.com, davidlohr@hp.com

Subject: [merged] maintainers-add-myself-as-gpt-maintainer.patch removed from -mm tree
To: davidlohr@hp.com,Matt_Domsch@dell.com,axboe@kernel.dk,matt.fleming@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:54:03 -0800


The patch titled
     Subject: MAINTAINERS: add Davidlohr as GPT maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-gpt-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: MAINTAINERS: add Davidlohr as GPT maintainer

Add a new entry for the GPT standard. Any future changes will now be routed
through linux-efi.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Acked-by: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~maintainers-add-myself-as-gpt-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-myself-as-gpt-maintainer
+++ a/MAINTAINERS
@@ -3833,6 +3833,12 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/gspca/
 
+GUID PARTITION TABLE (GPT)
+M:	Davidlohr Bueso <davidlohr@hp.com>
+L:	linux-efi@vger.kernel.org
+S:	Maintained
+F:	block/partitions/efi.*
+
 STK1160 USB VIDEO CAPTURE DRIVER
 M:	Ezequiel Garcia <elezegarcia@gmail.com>
 L:	linux-media@vger.kernel.org
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
mm-mmapc-add-mlock_future_check-helper.patch
mm-mlock-prepare-params-outside-critical-region.patch
partitions-efi-complete-documentation-of-gpt-kernel-param-purpose.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2.patch

