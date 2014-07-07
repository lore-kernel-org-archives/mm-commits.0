From: akpm@linux-foundation.org
Subject: + documentation-fix-typo-in-docbook-mtdnandtmpl.patch added to
 -mm tree
Date: Mon, 07 Jul 2014 16:07:29 -0700
Message-ID: <53bb2831.qx7F1LOPZGjcB3A2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:60572 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGGXHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:07:30 -0400
Received: by mail-vc0-f201.google.com with SMTP id ij19so720475vcb.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:07:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: fix typos in DocBook/mtdnand.tmpl
has been added to the -mm tree.  Its filename is
     documentation-fix-typo-in-docbook-mtdnandtmpl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-fix-typo-in-docbook-mtdnandtmpl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-fix-typo-in-docbook-mtdnandtmpl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masanari Iida <standby24x7@gmail.com>
Subject: Documentation: fix typos in DocBook/mtdnand.tmpl

Fix spelling typos found in DocBook/mtdnand.tmpl.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/mtdnand.tmpl |   30 +++++++++++++--------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN Documentation/DocBook/mtdnand.tmpl~documentation-fix-typo-in-docbook-mtdnandtmpl Documentation/DocBook/mtdnand.tmpl
--- a/Documentation/DocBook/mtdnand.tmpl~documentation-fix-typo-in-docbook-mtdnandtmpl
+++ a/Documentation/DocBook/mtdnand.tmpl
@@ -91,7 +91,7 @@
 		<listitem><para>
 	  	[MTD Interface]</para><para>
 		These functions provide the interface to the MTD kernel API. 
-		They are not replacable and provide functionality
+		They are not replaceable and provide functionality
 		which is complete hardware independent.
 		</para></listitem>
 		<listitem><para>
@@ -100,14 +100,14 @@
 		</para></listitem>
 		<listitem><para>
 	  	[GENERIC]</para><para>
-		Generic functions are not replacable and provide functionality
+		Generic functions are not replaceable and provide functionality
 		which is complete hardware independent.
 		</para></listitem>
 		<listitem><para>
 	  	[DEFAULT]</para><para>
 		Default functions provide hardware related functionality which is suitable
 		for most of the implementations. These functions can be replaced by the
-		board driver if neccecary. Those functions are called via pointers in the
+		board driver if necessary. Those functions are called via pointers in the
 		NAND chip description structure. The board driver can set the functions which
 		should be replaced by board dependent functions before calling nand_scan().
 		If the function pointer is NULL on entry to nand_scan() then the pointer
@@ -264,7 +264,7 @@ static void board_hwcontrol(struct mtd_i
 			is set up nand_scan() is called. This function tries to
 			detect and identify then chip. If a chip is found all the
 			internal data fields are initialized accordingly.
-			The structure(s) have to be zeroed out first and then filled with the neccecary 
+			The structure(s) have to be zeroed out first and then filled with the necessary 
 			information about the device.
 		</para>
 		<programlisting>
@@ -327,7 +327,7 @@ module_init(board_init);
 	<sect1 id="Exit_function">
 		<title>Exit function</title>
 		<para>
-			The exit function is only neccecary if the driver is
+			The exit function is only necessary if the driver is
 			compiled as a module. It releases all resources which
 			are held by the chip driver and unregisters the partitions
 			in the MTD layer.
@@ -494,7 +494,7 @@ static void board_select_chip (struct mt
 				in this case. See rts_from4.c and diskonchip.c for 
 				implementation reference. In those cases we must also
 				use bad block tables on FLASH, because the ECC layout is
-				interferring with the bad block marker positions.
+				interfering with the bad block marker positions.
 				See bad block table support for details.
 			</para>
 		</sect2>
@@ -542,7 +542,7 @@ static void board_select_chip (struct mt
 		<para>	
 			nand_scan() calls the function nand_default_bbt(). 
 			nand_default_bbt() selects appropriate default
-			bad block table desriptors depending on the chip information
+			bad block table descriptors depending on the chip information
 			which was retrieved by nand_scan().
 		</para>
 		<para>
@@ -554,7 +554,7 @@ static void board_select_chip (struct mt
 		<sect2 id="Flash_based_tables">
 			<title>Flash based tables</title>
 			<para>
-				It may be desired or neccecary to keep a bad block table in FLASH. 
+				It may be desired or necessary to keep a bad block table in FLASH. 
 				For AG-AND chips this is mandatory, as they have no factory marked
 				bad blocks. They have factory marked good blocks. The marker pattern
 				is erased when the block is erased to be reused. So in case of
@@ -565,10 +565,10 @@ static void board_select_chip (struct mt
 				of the blocks.
 			</para>
 			<para>
-				The blocks in which the tables are stored are procteted against
+				The blocks in which the tables are stored are protected against
 				accidental access by marking them bad in the memory bad block
 				table. The bad block table management functions are allowed
-				to circumvernt this protection.
+				to circumvent this protection.
 			</para>
 			<para>
 				The simplest way to activate the FLASH based bad block table support 
@@ -592,7 +592,7 @@ static void board_select_chip (struct mt
 				User defined tables are created by filling out a 
 				nand_bbt_descr structure and storing the pointer in the
 				nand_chip structure member bbt_td before calling nand_scan(). 
-				If a mirror table is neccecary a second structure must be
+				If a mirror table is necessary a second structure must be
 				created and a pointer to this structure must be stored
 				in bbt_md inside the nand_chip structure. If the bbt_md 
 				member is set to NULL then only the main table is used
@@ -666,7 +666,7 @@ static void board_select_chip (struct mt
 				<para>
 				For automatic placement some blocks must be reserved for
 				bad block table storage. The number of reserved blocks is defined 
-				in the maxblocks member of the babd block table description structure.
+				in the maxblocks member of the bad block table description structure.
 				Reserving 4 blocks for mirrored tables should be a reasonable number. 
 				This also limits the number of blocks which are scanned for the bad
 				block table ident pattern.
@@ -1068,11 +1068,11 @@ in this page</entry>
   <chapter id="filesystems">
      	<title>Filesystem support</title>
 	<para>
-		The NAND driver provides all neccecary functions for a
+		The NAND driver provides all necessary functions for a
 		filesystem via the MTD interface.
 	</para>
 	<para>
-		Filesystems must be aware of the NAND pecularities and
+		Filesystems must be aware of the NAND peculiarities and
 		restrictions. One major restrictions of NAND Flash is, that you cannot 
 		write as often as you want to a page. The consecutive writes to a page, 
 		before erasing it again, are restricted to 1-3 writes, depending on the 
@@ -1222,7 +1222,7 @@ in this page</entry>
 #define NAND_BBT_VERSION	0x00000100
 /* Create a bbt if none axists */
 #define NAND_BBT_CREATE		0x00000200
-/* Write bbt if neccecary */
+/* Write bbt if necessary */
 #define NAND_BBT_WRITE		0x00001000
 /* Read and write back block contents when writing bbt */
 #define NAND_BBT_SAVECONTENT	0x00002000
_

Patches currently in -mm which might be from standby24x7@gmail.com are

documentation-fix-typo-in-docbook-mtdnandtmpl.patch
linux-next.patch

