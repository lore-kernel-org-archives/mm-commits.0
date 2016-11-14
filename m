From: akpm@linux-foundation.org
Subject: + dt-add-documentation-of-hotpluggable-memory-property.patch
 added to -mm tree
Date: Mon, 14 Nov 2016 15:05:19 -0800
Message-ID: <582a432f.KbBgySVxOMbNyYKG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56954 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939765AbcKNXFV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 18:05:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, apopple@au1.ibm.com, benh@kernel.crashing.org, bharata@linux.vnet.ibm.com, bsingharora@gmail.com, frowand.list@gmail.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, nfont@linux.vnet.ibm.com, paulus@samba.org, robh+dt@kernel.org, stewart@linux.vnet.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: dt: add documentation of "hotpluggable" memory property
has been added to the -mm tree.  Its filename is
     dt-add-documentation-of-hotpluggable-memory-property.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dt-add-documentation-of-hotpluggable-memory-property.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dt-add-documentation-of-hotpluggable-memory-property.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: dt: add documentation of "hotpluggable" memory property

Summarize the "hotpluggable" property of dt memory nodes.

Link: http://lkml.kernel.org/r/1479160961-25840-6-git-send-email-arbab@linux.vnet.ibm.com
Signed-off-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alistair Popple <apopple@au1.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/booting-without-of.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/devicetree/booting-without-of.txt~dt-add-documentation-of-hotpluggable-memory-property Documentation/devicetree/booting-without-of.txt
--- a/Documentation/devicetree/booting-without-of.txt~dt-add-documentation-of-hotpluggable-memory-property
+++ a/Documentation/devicetree/booting-without-of.txt
@@ -974,6 +974,13 @@ compatibility.
       4Gb. Some vendors prefer splitting those ranges into smaller
       segments, but the kernel doesn't care.
 
+  Additional properties:
+
+    - hotpluggable : The presence of this property provides an explicit
+      hint to the operating system that this memory may potentially be
+      removed later. The kernel can take this into consideration when
+      doing nonmovable allocations and when laying out memory zones.
+
   e) The /chosen node
 
   This node is a bit "special". Normally, that's where Open Firmware
_

Patches currently in -mm which might be from arbab@linux.vnet.ibm.com are

powerpc-mm-allow-memory-hotplug-into-a-memoryless-node.patch
mm-remove-x86-only-restriction-of-movable_node.patch
mm-enable-config_movable_node-on-non-x86-arches.patch
of-fdt-mark-hotpluggable-memory.patch
dt-add-documentation-of-hotpluggable-memory-property.patch

