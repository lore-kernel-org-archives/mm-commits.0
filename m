From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-entry-for-kernel-selftest-framework.patch removed from -mm
 tree
Date: Tue, 14 Oct 2014 11:19:15 -0700
Message-ID: <543d6923.Qu41kgpGXagm8fgD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbaJNSTO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add entry for Kernel Selftest Framework
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-kernel-selftest-framework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: MAINTAINERS: add entry for Kernel Selftest Framework

Add entry for Kernel Selftest Framework.  Individual tests continue to be
maintained by the maintainers for those areas.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-entry-for-kernel-selftest-framework MAINTAINERS
--- a/MAINTAINERS~maintainers-add-entry-for-kernel-selftest-framework
+++ a/MAINTAINERS
@@ -5300,6 +5300,13 @@ F:	include/linux/lockd/
 F:	include/linux/sunrpc/
 F:	include/uapi/linux/sunrpc/
 
+KERNEL SELFTEST FRAMEWORK
+M:	Shuah Khan <shuahkh@osg.samsung.com>
+L:	linux-api@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/shuah/linux-kselftest
+S:	Maintained
+F:	tools/testing/selftests
+
 KERNEL VIRTUAL MACHINE (KVM)
 M:	Gleb Natapov <gleb@kernel.org>
 M:	Paolo Bonzini <pbonzini@redhat.com>
_

Patches currently in -mm which might be from shuahkh@osg.samsung.com are

origin.patch
linux-next.patch

