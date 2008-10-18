From: akpm@linux-foundation.org
Subject: - fix-random-typos.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:29 -0700
Message-ID: <200810182311.m9INBT1g027739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbYJRXMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dth@cistron.nl, avi@qumranet.com, kaber@trash.net, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     fix random typos
has been removed from the -mm tree.  Its filename was
     fix-random-typos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -115,7 +115,7 @@ int nf_conntrack_acct_init(struct net *n
 
 	if (net_eq(net, &init_net)) {
 #ifdef CONFIG_NF_CT_ACCT
-		printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use\n");
+	printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use\n");
 		printk(KERN_WARNING "nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or\n");
 		printk(KERN_WARNING "sysctl net.netfilter.nf_conntrack_acct=1 to enable it.\n");
 #endif
_

Patches currently in -mm which might be from dth@cistron.nl are

origin.patch

