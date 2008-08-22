From: akpm@linux-foundation.org
Subject: + fix-random-typos.patch added to -mm tree
Date: Fri, 22 Aug 2008 12:00:58 -0700
Message-ID: <200808221900.m7MJ0wIB011261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214AbYHVTBx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 15:01:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dth@cistron.nl, avi@qumranet.com, kaber@trash.net, starvik@axis.com


The patch titled
     fix random typos
has been added to the -mm tree.  Its filename is
     fix-random-typos.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix random typos
From: Danny ter Haar <dth@cistron.nl>

Signed-off-by: Danny ter Haar <dth@cistron.nl>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cris/README         |    2 +-
 Documentation/ia64/kvm.txt        |    9 +++++----
 net/netfilter/nf_conntrack_acct.c |    2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff -puN Documentation/cris/README~fix-random-typos Documentation/cris/README
--- a/Documentation/cris/README~fix-random-typos
+++ a/Documentation/cris/README
@@ -27,7 +27,7 @@ operating system.
 The ETRAX 100LX chip
 --------------------
 
-For reference, plase see the press-release:
+For reference, please see the press-release:
 
 http://www.axis.com/news/us/001101_etrax.htm
 
diff -puN Documentation/ia64/kvm.txt~fix-random-typos Documentation/ia64/kvm.txt
--- a/Documentation/ia64/kvm.txt~fix-random-typos
+++ a/Documentation/ia64/kvm.txt
@@ -1,7 +1,8 @@
-Currently, kvm module in EXPERIMENTAL stage on IA64. This means that
-interfaces are not stable enough to use. So, plase had better don't run
-critical applications in virtual machine. We will try our best to make it
-strong in future versions!
+Currently, kvm module is in EXPERIMENTAL stage on IA64. This means that
+interfaces are not stable enough to use. So, please don't run critical
+applications in virtual machine.
+We will try our best to improve it in future versions!
+
 				Guide: How to boot up guests on kvm/ia64
 
 This guide is to describe how to enable kvm support for IA-64 systems.
diff -puN net/netfilter/nf_conntrack_acct.c~fix-random-typos net/netfilter/nf_conntrack_acct.c
--- a/net/netfilter/nf_conntrack_acct.c~fix-random-typos
+++ a/net/netfilter/nf_conntrack_acct.c
@@ -69,7 +69,7 @@ int nf_conntrack_acct_init(void)
 	int ret;
 
 #ifdef CONFIG_NF_CT_ACCT
-	printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use\n");
+	printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use\n");
 	printk(KERN_WARNING "nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or\n");
 	printk(KERN_WARNING "sysctl net.netfilter.nf_conntrack_acct=1 to enable it.\n");
 #endif
_

Patches currently in -mm which might be from dth@cistron.nl are

fix-random-typos.patch

