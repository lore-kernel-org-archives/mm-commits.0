Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980514;
	b=O/qZhdzo8EZQbbhayb2EW9UjoDUdt48r/0vYp2N3UC7YLki5bTl3HW7e1Uyh3NQQBnRT
	 iVNJaMfQpuRnoxDgMhtbIQLzgGhrbFwpjyXypH9CWrHWCQkBXEs+zUEKqBP/GOujYpVgS
	 c7UExTBCsZ/jTcTd+FIUZtDCZU89s8ziexBJZuBmO3mEovN5AAcLemP8zQmNY1NS38RPr
	 oFdZuN4ZxVaFI1Z1s7eBs2tih3mHhuKyEulYYVdRJp3VZ9cU9grn1wTiVGO9ZDcQKt9xw
	 6viq1AWuiJ5wuRJXGIqyqU5XXhtB/t+s9JsTZxFKh/GpKP7lvO9Wpa1TRWEh/KeuXhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980514;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=lgswRhiX+xDAvxdcru1EACWtt/7qPzaFmmHtEt5/VFc=;
	b=FwbYca0eIfWZHrDrate0oqpsc1WRHCAtzOggFEkSWGIH4TQUefwRUHjn7ri97tRYUDJu
	 zfZxufHyoERpanKOafTSjXizDwgLh1j52gNIi8HozPfr45//r3iZT0q4UCKTbdy0UIRB6
	 XNvr32A49aOg8fOZfuuOkdPprPn+0WnYnKNH2BsB5q/qaEl25mW62ySxphvD0IjKDrh8A
	 VzyVqnf1Yr3bAPhtUGai3zZTYQdI+eOCgnCffR2fQGBdojP9r7eddtEqpjQzKiE5BZCnf
	 yugY28/6VdbZUpEDOk8JJMk3wb5tvRU82yvJmU+vsl5RGOxNVed6hESvXVenAJHCWYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=w99cm8Gr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A2E606A331
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=w99cm8Gr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDE91F000D0;
	Wed, 18 Nov 2026 05:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980513;
	bh=lgswRhiX+xDAvxdcru1EACWtt/7qPzaFmmHtEt5/VFc=;
	h=Date:To:From:Subject;
	b=w99cm8GraJujkyx07fyL8O+4JTJXnIzp/rWTXKHAhO+oCRgoGZbHinTwT7zHTVzox
	 RB/XLLL0VXsWTnhYqfe2/suiUID+RTLuO+Olnk4UxKS+PabH5Ga8HplUi31sOmvoDN
	 P6EwUM7TvaraJM3Djm1/6LIqIndcyyyRNL0i1Y0Y=
Date: Tue, 17 Nov 2026 21:41:53 -0800
To: mm-commits@vger.kernel.org,wy@wyuan.org,users@kernel.org,
	skhan@linuxfoundation.org,si.yanteng@linux.dev,rdunlap@infradead.org,
	petr.pavlu@suse.com,joe@perches.com,federico.vaga@vaga.pv.it,
	dzm91@hust.edu.cn,corbet@lwn.net,chenyou910331@gmail.com,
	carlos.bilbao@kernel.org,avadhut.naik@amd.com,alexs@kernel.org,
	akiyks@gmail.com,konstantin@linuxfoundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] docs-submitting-patches-make-lkml-a-list-of-last-resort-again.patch removed from -mm tree
Message-Id: <20261118054153.CCDE91F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: docs: submitting-patches: make LKML a list of last resort again
has been removed from the -mm tree.  Its filename was
     docs-submitting-patches-make-lkml-a-list-of-last-resort-again.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: docs: submitting-patches: make LKML a list of last resort again
Date: Fri, 13 Nov 2026 18:02:46 -0500

Commit 77167b966b7e ("docs: submitting-patches: clarify the role of LKML")
changed the documentation to say that all patches should be sent to LKML
by default, because get_maintainer.pl always suggested it.

Now that get_maintainer.pl only falls back to THE REST when no other
matching section provides a mailing list, update the documentation to
match: send patches to the subsystem-specific list, and use LKML only when
there isn't one.

Link: https://lore.kernel.org/20261113-get-maintainer-the-rest-fallback-v3-2-36ee5a3e8d13@linuxfoundation.org
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Federico Vaga <federico.vaga@vaga.pv.it>
Cc: Akira Yokosawa <akiyks@gmail.com>
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Avadhut Naik <avadhut.naik@amd.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Chen-Yu Yeh <chenyou910331@gmail.com>
Cc: Weijie Yuan <wy@wyuan.org>
Cc: <users@kernel.org>

 Documentation/process/submitting-patches.rst |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/Documentation/process/submitting-patches.rst~docs-submitting-patches-make-lkml-a-list-of-last-resort-again
+++ a/Documentation/process/submitting-patches.rst
@@ -239,9 +239,12 @@ patches as arguments to scripts/get_main
 maintainer for the subsystem you are working on, Andrew Morton
 (akpm@linux-foundation.org) serves as a maintainer of last resort.
 
-linux-kernel@vger.kernel.org should be used by default for all patches, but the
-volume on that list has caused a number of developers to tune it out.  Please
-do not spam unrelated lists and unrelated people, though.
+You should also normally choose at least one mailing list to receive a copy of
+your patch set.  Look in the MAINTAINERS file for a subsystem-specific list;
+your patch will probably get more attention there.
+linux-kernel@vger.kernel.org functions as a list of last resort for patches
+that do not have a subsystem-specific list.  Please do not spam unrelated lists
+and unrelated people, though.
 
 Many kernel-related lists are hosted at kernel.org; you can find a list
 of them at https://subspace.kernel.org.  There are kernel-related lists
_

Patches currently in -mm which might be from konstantin@linuxfoundation.org are


