Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E688E3148DA
	for <mm-commits@vger.kernel.org>; Tue,  6 Oct 2026 23:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330292; cv=none; b=Qx1GGEDtMfvDRw2wj3syMG3SW7k9SoCafcxOKfGfGguW9cPedx9UHY+iwGKaRyVhpxXag59wOIjy9Ge8N7yKYSR9IRLUjSK3lY+YdDtUK++2o7F1XDMHZrrB/J4HJdxf08QYZe2BCJUrWrSICHJA8hcbiEm53KDOANn9K/ADMM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330292; c=relaxed/simple;
	bh=cxVM2StP0ZoTHJOeJBym6d5j2rfJ23CO/Pk9AgEPZHE=;
	h=Date:To:From:Subject:Message-Id; b=XMXRO8thka0uO+U8Jc3hMgKRLzBIRieARMfzEF/Bb03gsWt0bkEynxTipH46tZdLXBzrIgDnfhBU0wizYvRov4xnMJCI1VgTNMEGdYs7az14ID1gbUKoCKotdWYvTyyTnKCXzEmgQ7sPJWqWlmiyLyFv8J7UmCtUj0qqYaNFbQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aYidZl6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aYidZl6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1951F0089B;
	Tue,  6 Oct 2026 23:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791330290;
	bh=SQv4HO1ytAmd78dOiIfiQGSuGm+/VJxcL+4op/BbuDU=;
	h=Date:To:From:Subject;
	b=aYidZl6ukHFEleWth0/oIZIBXbjJotFPOmtrAGVBzCJqh6/z+HbmfsUokBxrqe2Wr
	 rbQgFNRuYSDNIyhrBb94syX6SX1WESNRhBHOeW6Bdt7E8+QRtsdjVLjT4nCaPBGlmO
	 ID1hsQMeNh3BueX2+iL34Taf/uCpQS2ok9me+/1c=
Date: Tue, 06 Oct 2026 16:44:50 -0700
To: mm-commits@vger.kernel.org,john.garry@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-addresses-for-john-garry.patch removed from -mm tree
Message-Id: <20261006234450.7E1951F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update addresses for John Garry
has been removed from the -mm tree.  Its filename was
     mailmap-update-addresses-for-john-garry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Garry <john.garry@linux.dev>
Subject: mailmap: update addresses for John Garry
Date: Wed, 23 Sep 2026 08:53:24 +0100

Point any employment addresses at my personal dev address.

Link: https://lore.kernel.org/20260923075324.1382927-1-john.garry@linux.dev
Signed-off-by: John Garry <john.garry@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-addresses-for-john-garry
+++ a/.mailmap
@@ -461,7 +461,8 @@ Johan Hovold <johan@kernel.org> <jhovold
 Johan Hovold <johan@kernel.org> <johan@hovoldconsulting.com>
 John Crispin <john@phrozen.org> <blogic@openwrt.org>
 John Fastabend <john.fastabend@gmail.com> <john.r.fastabend@intel.com>
-John Garry <john.g.garry@oracle.com> <john.garry@huawei.com>
+John Garry <john.garry@linux.dev> <john.garry@huawei.com>
+John Garry <john.garry@linux.dev> <john.g.garry@oracle.com>
 John Keeping <john@keeping.me.uk> <john@metanate.com>
 John Moon <john@jmoon.dev> <quic_johmoo@quicinc.com>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
_

Patches currently in -mm which might be from john.garry@linux.dev are


