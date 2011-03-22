From: akpm@linux-foundation.org
Subject: [folded] st-spear-pcie-gadget-documentation-for-support-of-multiple-device.patch removed from -mm tree
Date: Tue, 22 Mar 2011 16:02:28 -0700
Message-ID: <201103222302.p2MN2SVJ000381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400Ab1CVXD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 19:03:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pratyush.anand@st.com, jbarnes@virtuousgeek.org, randy.dunlap@oracle.com, shiraz.hashim@st.com, viresh.kumar@st.com, mm-commits@vger.kernel.org


The patch titled
     ST SPEAr: PCIe Gadget: Documentation for support of multiple device
has been removed from the -mm tree.  Its filename was
     st-spear-pcie-gadget-documentation-for-support-of-multiple-device.patch

This patch was dropped because it was folded into st-spear-pcie-gadget-suppport.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ST SPEAr: PCIe Gadget: Documentation for support of multiple device
From: Pratyush Anand <pratyush.anand@st.com>

Directory naming scheme for multiple PCIe device has been mentioned.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/configfs-spear-pcie-gadget |    3 ++-
 Documentation/misc-devices/spear-pcie-gadget.txt     |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN Documentation/ABI/testing/configfs-spear-pcie-gadget~st-spear-pcie-gadget-documentation-for-support-of-multiple-device Documentation/ABI/testing/configfs-spear-pcie-gadget
--- a/Documentation/ABI/testing/configfs-spear-pcie-gadget~st-spear-pcie-gadget-documentation-for-support-of-multiple-device
+++ a/Documentation/ABI/testing/configfs-spear-pcie-gadget
@@ -13,7 +13,8 @@ Description:
 	in /config directory use:
 	# mount -t configfs none /config/
 
-	/config/pcie-gadget/
+	For nth PCIe Device Controller
+	/config/pcie-gadget.n/
 		link ... used to enable ltssm and read its status.
 		int_type ...used to configure and read type of supported
 			interrupt
diff -puN Documentation/misc-devices/spear-pcie-gadget.txt~st-spear-pcie-gadget-documentation-for-support-of-multiple-device Documentation/misc-devices/spear-pcie-gadget.txt
--- a/Documentation/misc-devices/spear-pcie-gadget.txt~st-spear-pcie-gadget-documentation-for-support-of-multiple-device
+++ a/Documentation/misc-devices/spear-pcie-gadget.txt
@@ -66,7 +66,8 @@ Node programming example
 Program all PCIe registers in such a way that when this device is connected
 to the PCIe host, then host sees this device as 1MB RAM.
 #mount -t configfs none /Config
-# cd /config/pcie_gadget/
+For nth PCIe Device Controller
+# cd /config/pcie_gadget.n/
 Now you have all the nodes in this directory.
 program vendor id as 0x104a
 # echo 104A >> vendor_id
_

Patches currently in -mm which might be from pratyush.anand@st.com are

st-spear-pcie-gadget-suppport.patch

