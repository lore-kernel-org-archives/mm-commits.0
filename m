Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980526;
	b=kMbx3nL/QtMuQu/H0JrungXJL2zztg2FAEZMTR02ha8HjHeMlc4fWwyBvdJq4u9/8kIc
	 3457P+knOWmUDXcx7SwQmREul+w0nUILZkL0WJGoFsvM9L2YprzKcORVSh38llHlftcYf
	 otiDUMj3fis8KRfapa/yZ9yRtrIe5DHqZQ2LfAIWsLmp5mYUhewDcgE3kjAN/io8gS99r
	 T1xYf6bBDpu5zUXY2hpicN7b6ddNS0cMWDxS2+nrMbiCnskm+b5Rlo42BuiL1roWifbAS
	 uiPe7N+NMOQAlzfGTEkgPjSlig5t7LxGkSobOraaDZ+0fOkjTT0+t05JP9sJ+4zabiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980526;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YN3qhr/pWjvm3PoR4UtE+nHZVFAeh/3SgM1+Le1Jn6I=;
	b=y6mmeljYkqifzqB53YT8zeE5p+Ek8lpP5At3gPyJKCmF6NekmeDZsvZBz0iNGmccnZS3
	 /p64K4Dr8+lRL1COx7/FKqdT49uwK5mq3ctq6GwPiMIKxi1oEw+K5ueQZYehvONzzSfwe
	 LzQs+FyjFHrSoR5bzuyq5JQezMD4zbyLu/vDoEVqbzbZ72j71+oAjtF0it3nYxZJNvK0M
	 j0PjDXX0TYVMuzoE+HsqNx2VYzl5Y4ymahcto6Tz1tH89Ob/J4r17t3C5aKAPgaX+4hZ4
	 3ggW+N9lcu+BSOgaQHVI9mGG5HeddCYncu2qVLpRZM4XY9/SMT1ywHEMH92pVZWmvow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TFWLn4w4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A256E606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TFWLn4w4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EB51F0028F;
	Wed, 18 Nov 2026 05:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980526;
	bh=YN3qhr/pWjvm3PoR4UtE+nHZVFAeh/3SgM1+Le1Jn6I=;
	h=Date:To:From:Subject;
	b=TFWLn4w49oKwBxgeOjCBmOZpcZyFsWC8nWUL18rUXd0AEFeM6mndWL26AU3q7rjY3
	 mURHQt2LR+lB9Y7UgWyf3WeiCtGpwSXAsbUlyz1VLHMBXJWtSP+a/O/VSvPkeRX8zK
	 pR/mHr2tTNArIjHjpyP8tmKQvGvvOsBRP9mxnQ8s=
Date: Tue, 17 Nov 2026 21:42:05 -0800
To: mm-commits@vger.kernel.org,guodong.xu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] mailmap-update-entry-for-guodong-xu.patch removed from -mm tree
Message-Id: <20261118054206.68EB51F0028F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mailmap: update entry for Guodong Xu
has been removed from the -mm tree.  Its filename was
     mailmap-update-entry-for-guodong-xu.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guodong Xu <guodong.xu@linux.dev>
Subject: mailmap: update entry for Guodong Xu
Date: Fri, 6 Nov 2026 16:30:48 -0500

Use my linux.dev address for kernel correspondence, including for
contributions made with my other email addresses. It is not tied to
a personal or employer mailbox.

Link: https://lore.kernel.org/7e9369cf1473539bafe9cb90207ba6fe98b534ca.1794001419.git.guodong.xu@linux.dev
Signed-off-by: Guodong Xu <guodong.xu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 .mailmap |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/.mailmap~mailmap-update-entry-for-guodong-xu
+++ a/.mailmap
@@ -358,8 +358,10 @@ Gokul Sriram Palanisamy <quic_gokulsri@q
 Govindaraj Saminathan <quic_gsamin@quicinc.com> <gsamin@codeaurora.org>
 Guo Ren <guoren@kernel.org> <guoren@linux.alibaba.com>
 Guo Ren <guoren@kernel.org> <ren_guo@c-sky.com>
-Guodong Xu <docular.xu@gmail.com> <guodong.xu@linaro.org>
-Guodong Xu <docular.xu@gmail.com> <guodong@riscstar.com>
+Guodong Xu <guodong.xu@linux.dev> <docular.xu@gmail.com>
+Guodong Xu <guodong.xu@linux.dev> <guodong.xu@linaro.org>
+Guodong Xu <guodong.xu@linux.dev> <guodong.xu@oss.qualcomm.com>
+Guodong Xu <guodong.xu@linux.dev> <guodong@riscstar.com>
 Guru Das Srinagesh <linux@gurudas.dev>
 Guru Das Srinagesh <linux@gurudas.dev> <quic_gurus@quicinc.com>
 Guru Das Srinagesh <linux@gurudas.dev> <gurus@codeaurora.org>
_

Patches currently in -mm which might be from guodong.xu@linux.dev are


