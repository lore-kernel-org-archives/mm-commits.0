Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980520;
	b=Lj7q5qo2IAm670t6qYzIkxPv9MAk/9RMNa0pycvhTEyVLt2RnRxJ7hgLTC7+8NeVW2oi
	 e0m+okG2+OFflbTiLN++rkXIfxcyslK4YOnAyVzKBvHXiib1lqgdM67zsS0tUFgnji50G
	 muwozF3Nz5ZlvR3/zeSTjezpvGg9IkjcDptBsZPOawSD3a42PRRNiBvYYVbs7J/kZ/PSk
	 Afe5ojdnl98MNUr8U0D3rjVcwGlgE4EugshLZyI+8laiwWcQOLpguTJScMI48pU7L5puh
	 hRdPfvhfoczzIWsHtT5DpRAJaRDF1P0T/9AFkGtdRCyc8t54THMakE7ukEAn8MsHkGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980520;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=PbpW943sbHI42ihb8UIePqM7c7NSACQUUKkaWi18YU4=;
	b=nbJBQ2DtsrRNRz056aS0dQk6rjcENCUfZg0k66caEXkyeFvqoUmBSwyWewQ5VLe5REpV
	 CrjOsr4YmF9+h3LfeYJVTBGcEu3Byu1m/7NRE8MzrNFyAcvBgbfZ4GKzLu/9fyp+X2lcu
	 ZGmpWrHIGSmG6mM0D49j4I+x9rTC+jHfXhO1wXU7qi42pXKZsdWDb9FMt5Aly1BXlps6i
	 cqx4KU9Uo2qYkaArCOqVHJGxfgXj2zk4YtuX+aX+lpjBEfAL+glbtPVMqzq/oFLi0iKHI
	 q/Q//E50ufGCRP1Ligp00EhMwApkYATwl8tfWLrjEmU5jwfyNsAl4TAzvk/ea9/4C3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="jWjlm/2H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F58606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jWjlm/2H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440581F0181D;
	Wed, 18 Nov 2026 05:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980520;
	bh=PbpW943sbHI42ihb8UIePqM7c7NSACQUUKkaWi18YU4=;
	h=Date:To:From:Subject;
	b=jWjlm/2HvUMTwqbJy7aVoiudY6Y6aR77v4WPYWPa/jR9MHSIP7/mNx5MhhscpLpDD
	 qs1VH38Frev+A1EPzUOwrjhZAMrd1U/FNVLKWZfjG3ziMd4UTJCjjwC1qQ15cJLYQb
	 pQeNzaL3pXn1a8oS0puby5ZyrYcKtlGRG26ju3XM=
Date: Tue, 17 Nov 2026 21:41:59 -0800
To: mm-commits@vger.kernel.org,kuba@kernel.org,jeff.johnson@oss.qualcomm.com,
	hawk@kernel.org,dianders@chromium.org,cel@kernel.org,
	bastien.curutchet@bootlin.com,alex@sverdlin.org,namjain@linux.microsoft.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] mailmap-update-email-address-for-naman-jain.patch removed from -mm tree
Message-Id: <20261118054200.440581F0181D@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mailmap: update email address for Naman Jain
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-naman-jain.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naman Jain <namjain@linux.microsoft.com>
Subject: mailmap: update email address for Naman Jain
Date: Tue, 17 Nov 2026 08:45:42 +0000

My Qualcomm email address is no longer accessible. Map it to my current
Microsoft email address.

Link: https://lore.kernel.org/20261117084542.2076622-1-namjain@linux.microsoft.com
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Alexander Sverdlin <alex@sverdlin.org>
Cc: Chuck Lever <cel@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-naman-jain
+++ a/.mailmap
@@ -695,6 +695,7 @@ Mythri P K <mythripk@ti.com>
 Nadav Amit <nadav.amit@gmail.com> <namit@vmware.com>
 Nadav Amit <nadav.amit@gmail.com> <namit@cs.technion.ac.il>
 Nadia Yvette Chambers <nyc@holomorphy.com> William Lee Irwin III <wli@holomorphy.com>
+Naman Jain <namjain@linux.microsoft.com> <quic_namajain@quicinc.com>
 Naoya Horiguchi <nao.horiguchi@gmail.com> <n-horiguchi@ah.jp.nec.com>
 Naoya Horiguchi <nao.horiguchi@gmail.com> <naoya.horiguchi@nec.com>
 Natalie Vock <nat@pixelcluster.dev> <friedrich.vock@gmx.de>
_

Patches currently in -mm which might be from namjain@linux.microsoft.com are


