From: akpm@linux-foundation.org
Subject: - ecryptfs-kerneldoc-for-ecryptfs_parse_tag_70_packet.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:33 -0800
Message-ID: <200901072218.n07MIXOX018043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762953AbZAGWhy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, dustin.kirkland@gmail.com, sandeen@redhat.com, shaggy@us.ibm.com, tchicks@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: kerneldoc for ecryptfs_parse_tag_70_packet()
has been removed from the -mm tree.  Its filename was
     ecryptfs-kerneldoc-for-ecryptfs_parse_tag_70_packet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: kerneldoc for ecryptfs_parse_tag_70_packet()
From: Michael Halcrow <mhalcrow@us.ibm.com>

Kerneldoc updates for ecryptfs_parse_tag_70_packet().

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dustin Kirkland <dustin.kirkland@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Tyler Hicks <tchicks@us.ibm.com>
Cc: David Kleikamp <shaggy@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-kerneldoc-for-ecryptfs_parse_tag_70_packet fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-kerneldoc-for-ecryptfs_parse_tag_70_packet
+++ a/fs/ecryptfs/keystore.c
@@ -771,6 +771,17 @@ struct ecryptfs_parse_tag_70_packet_sill
 /**
  * parse_tag_70_packet - Parse and process FNEK-encrypted passphrase packet
  * @filename: This function kmalloc's the memory for the filename
+ * @filename_size: This function sets this to the amount of memory
+ *                 kmalloc'd for the filename
+ * @packet_size: This function sets this to the the number of octets
+ *               in the packet parsed
+ * @mount_crypt_stat: The mount-wide cryptographic context
+ * @data: The memory location containing the start of the tag 70
+ *        packet
+ * @max_packet_size: The maximum legal size of the packet to be parsed
+ *                   from @data
+ *
+ * Returns zero on success; non-zero otherwise
  */
 int
 ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
notify_change-callers-must-hold-i_mutex.patch

