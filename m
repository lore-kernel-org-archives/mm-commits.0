Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B553153565
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 11:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410854; cv=none; b=Zfe6nE8yz4ILOqfRCAWuw2eZvcnSshYhyLIHm+XPTcwL3i8Cvgu1dLpulDLSID2z/+dDSHioDoGxZG1D6RHDJYO/gDREMl+gvD3NbceRRqiR78+KPysNbG72rvXGtxsFTc0Lox6sAxVBklNCiklA/pKMU5amh/9+rCJjIcCEvyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410854; c=relaxed/simple;
	bh=t3eUa164Z9HTbgzjrbMeRXRxT6mW+HCWYNzLWSZzxvc=;
	h=Date:To:From:Subject:Message-Id; b=ok78OMNx3SGZezIJbX8TDe1qnsls3ZdF316bHILAk21wMvOMEbt8JJRh9JvE9ikHegvDlk+PTdJCP0iiP963HMvJfne6/7RTPgbOmRixRIqw7jTP9yL3zcdMyuKkcCYgtIUmp8K6T+pRDlrQqdrnltNh9yhBjNBoDKSfknEu/6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vSZgEbIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vSZgEbIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B94C4CED3;
	Sat,  1 Feb 2025 11:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410854;
	bh=t3eUa164Z9HTbgzjrbMeRXRxT6mW+HCWYNzLWSZzxvc=;
	h=Date:To:From:Subject:From;
	b=vSZgEbIyf+hatIIXc/5bUe/5qseg+Rokz6srGbFqrqhn4irGCMdekfE8dP2y7oZeq
	 KugH8B11UqfjlZXXBLMt28lycldpDSlZXyPOUuUHVnwQXjbW76hogGikD43xa7SYHV
	 S0Y7EZmihaFthNuTRnpB6hh05lUAGeImllLPGq1A=
Date: Sat, 01 Feb 2025 03:54:13 -0800
To: mm-commits@vger.kernel.org,christopher.obbard@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-email-address-for-christopher-obbard.patch removed from -mm tree
Message-Id: <20250201115414.33B94C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: .mailmap: update email address for Christopher Obbard
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-christopher-obbard.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christopher Obbard <christopher.obbard@linaro.org>
Subject: .mailmap: update email address for Christopher Obbard
Date: Wed, 22 Jan 2025 12:04:27 +0000

Update my email address.

Link: https://lkml.kernel.org/r/20250122-wip-obbardc-update-email-v2-1-12bde6b79ad0@linaro.org
Signed-off-by: Christopher Obbard <christopher.obbard@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-christopher-obbard
+++ a/.mailmap
@@ -165,6 +165,7 @@ Christian Brauner <brauner@kernel.org> <
 Christian Brauner <brauner@kernel.org> <christian.brauner@ubuntu.com>
 Christian Marangi <ansuelsmth@gmail.com>
 Christophe Ricard <christophe.ricard@gmail.com>
+Christopher Obbard <christopher.obbard@linaro.org> <chris.obbard@collabora.com>
 Christoph Hellwig <hch@lst.de>
 Chuck Lever <chuck.lever@oracle.com> <cel@kernel.org>
 Chuck Lever <chuck.lever@oracle.com> <cel@netapp.com>
_

Patches currently in -mm which might be from christopher.obbard@linaro.org are


