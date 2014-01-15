From: akpm@linux-foundation.org
Subject: + kdump-add-sys-kernel-vmcoreinfo-abi-documentation.patch added
 to -mm tree
Date: Wed, 15 Jan 2014 14:32:51 -0800
Message-ID: <52d70c93.p8wfSpLqQmzkPRRS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaAOWcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jan 2014 17:32:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oomichi@mxs.nes.nec.co.jp, greg@kroah.com, da-x@monatomic.org, vgoyal@redhat.com

Subject: + kdump-add-sys-kernel-vmcoreinfo-abi-documentation.patch added to -mm tree
To: vgoyal@redhat.com,da-x@monatomic.org,greg@kroah.com,oomichi@mxs.nes.nec.co.jp
From: akpm@linux-foundation.org
Date: Wed, 15 Jan 2014 14:32:51 -0800


The patch titled
     Subject: kdump: add /sys/kernel/vmcoreinfo ABI documentation
has been added to the -mm tree.  Its filename is
     kdump-add-sys-kernel-vmcoreinfo-abi-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kdump-add-sys-kernel-vmcoreinfo-abi-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kdump-add-sys-kernel-vmcoreinfo-abi-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kdump: add /sys/kernel/vmcoreinfo ABI documentation

/sys/kernel/vmcoreinfo was introduced long back but there is no ABI
documentation.  This patch adds the documentation.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Cc: Dan Aloni <da-x@monatomic.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-vmcoreinfo |   14 ++++++++++++
 1 file changed, 14 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-kernel-vmcoreinfo
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-vmcoreinfo
@@ -0,0 +1,14 @@
+What:		/sys/kernel/vmcoreinfo
+Date:		October 2007
+KernelVersion:	2.6.24
+Contact:	Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
+		Kexec Mailing List <kexec@lists.infradead.org>
+		Vivek Goyal <vgoyal@redhat.com>
+Description
+		Shows physical address and size of vmcoreinfo ELF note.
+		First value contains physical address of note in hex and
+		second value contains the size of note in hex. This ELF
+		note info is parsed by second kernel and exported to user
+		space as part of ELF note in /proc/vmcore file. This note
+		contains various information like struct size, symbol
+		values, page size etc.
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch
kexec-add-sysctl-to-disable-kexec_load.patch
kdump-fix-exported-size-of-vmcoreinfo-note.patch
kdump-add-sys-kernel-vmcoreinfo-abi-documentation.patch
linux-next.patch

