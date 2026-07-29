Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576A624DCF9
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 00:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785285489; cv=none; b=vBISft5yaUA1YAeiCAtDfxN3w8MwkW7/r4OQyM91qE1rNMEkunQ5rpNegY+oji4/qhBLJbidm1jx7bT4PIcB2A/YDZAtPedHYMyVX+dC8GYX1GP21jt7KTRe46BxjX8eLzfibOF59OPpvsQoZx+5cJnp9YW54JIXpqDVYT3jgo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785285489; c=relaxed/simple;
	bh=qHBM+M+bt+fDVztJwwyyUKGvj1smF4ZG4RD8AVQJ2k4=;
	h=Date:To:From:Subject:Message-Id; b=ZW8xWCs++dlssTW8AEfxMmEjg5sqsE+DqBa02XgooN+KaB9L5KQ8Gv5MdW2aLAXtGuR45M2sQayndfgKE3SL+Mpfd8JbYKTnuaE6tqzCuIJSXX0DCLG6b7ehqZI7xmzHQnPlD/WNIbe+xXkDOcEy9bHRagjEmXTtaAKPxUycMO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QC8v3AL/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QC8v3AL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DFF1F000E9;
	Wed, 29 Jul 2026 00:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785285488;
	bh=s+8ATVzxNoCC1VtLI064G/1L/PrFcLsASNjEEDop+9o=;
	h=Date:To:From:Subject;
	b=QC8v3AL/7MiYQrdQkXQEOLU6KAFGXJMv5ja0LUtXf7R2zoSx0cqb4KMSly+1hQE5x
	 Q+3GBrYqSMZKj7dw+8TDJJA6n+/0mSluqH84pUOR6zlDM7ljdnoEQFO/ZSH5nXB7y2
	 VuBnFwdM8AMaOsnIKSmK4usoqcheeY5682YDPvqE=
Date: Tue, 28 Jul 2026 17:38:07 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,martink@posteo.de,kuba@kernel.org,aliceryhl@google.com,burak.emir@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-address-for-burak-emir.patch removed from -mm tree
Message-Id: <20260729003807.E8DFF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update address for Burak Emir
has been removed from the -mm tree.  Its filename was
     maintainers-update-address-for-burak-emir.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Burak Emir <burak.emir@gmail.com>
Subject: MAINTAINERS: update address for Burak Emir
Date: Sat, 18 Jul 2026 17:13:03 +0200

Update MAINTAINERS and .mailmap to point to my gmail.com address:
burak.emir@gmail.com.

Link: https://lore.kernel.org/20260718151303.2649-1-burak.emir@gmail.com
Signed-off-by: Burak Emir <burak.emir@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-address-for-burak-emir
+++ a/.mailmap
@@ -176,6 +176,7 @@ Brian Cain <bcain@kernel.org> <bcain@qui
 Brian King <brking@us.ibm.com>
 Brian Silverman <bsilver16384@gmail.com> <brian.silverman@bluerivertech.com>
 Bryan Tan <bryan-bt.tan@broadcom.com> <bryantan@vmware.com>
+Burak Emir <burak.emir@gmail.com> <bqe@google.com>
 Cai Huoqing <cai.huoqing@linux.dev> <caihuoqing@baidu.com>
 Casey Connolly <casey.connolly@linaro.org> <caleb.connolly@linaro.org>
 Casey Connolly <casey.connolly@linaro.org> <caleb@connolly.tech>
--- a/MAINTAINERS~maintainers-update-address-for-burak-emir
+++ a/MAINTAINERS
@@ -4634,7 +4634,7 @@ F:	rust/helpers/cpumask.c
 
 BITMAP API [RUST]
 M:	Alice Ryhl <aliceryhl@google.com>
-M:	Burak Emir <bqe@google.com>
+M:	Burak Emir <burak.emir@gmail.com>
 R:	Yury Norov <yury.norov@gmail.com>
 S:	Maintained
 F:	lib/find_bit_benchmark_rust.rs
_

Patches currently in -mm which might be from burak.emir@gmail.com are


