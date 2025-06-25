Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FFB217707
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892162; cv=none; b=OL/Pj4aoPghY0cyR0lWT6B5eSv/o5Yfb1YTwe0w4pQ+BURMmvOrQ/rQm4ThoCST8lgKlijG74m+6TKXar/Y8yuDoN/uwLho5q1B40oI3+DCUEnJ8JicOSuYNOzkxbI18g//JkDyF7xY6XW/yJdbE3OsJ4XxpXQIp8XuWlJ5yI6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892162; c=relaxed/simple;
	bh=KjlcKwj1OoaRYY3XruNE9vCNT/0G9vCrEomGCTFRubU=;
	h=Date:To:From:Subject:Message-Id; b=rr7copggqeh1VFkt8+vz35o94Fpc7rrFFaPM37xbqP+x5hz4nHcGse6Samaxz/A6BAeGjLX07V3qMUAETy3NC7bbcTu3JOXGtyUfY9JdYmsIPYZFSGWUW3naIX+1lmC98JJXG/BBhkB+c0cdibMXO0rCqcVmUpiNVn2lvCJn6wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OOD0P+8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OOD0P+8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1DBC4CEEA;
	Wed, 25 Jun 2025 22:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892162;
	bh=KjlcKwj1OoaRYY3XruNE9vCNT/0G9vCrEomGCTFRubU=;
	h=Date:To:From:Subject:From;
	b=OOD0P+8Uj5x33+DWz1tGG553hu485stKBrPOXspVRraaTKjEq/i1msBS3bMI3WV0U
	 hi2BRQjTq1uRb6liiHTkHNW6bWYXMRk3igEoODQ7UGB4z2Py8BZCm7RS9SvvZ/C68O
	 QMHhrQDje87CY98t2OfnfrpnZv/dPmHJfE3q3bNg=
Date: Wed, 25 Jun 2025 15:56:01 -0700
To: mm-commits@vger.kernel.org,hverkuil@xs4all.nl,zijun.hu@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-correct-name-for-a-historical-account-of-zijun-hu.patch removed from -mm tree
Message-Id: <20250625225602.2F1DBC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: correct name for a historical account of Zijun Hu
has been removed from the -mm tree.  Its filename was
     mailmap-correct-name-for-a-historical-account-of-zijun-hu.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zijun Hu <zijun.hu@oss.qualcomm.com>
Subject: mailmap: correct name for a historical account of Zijun Hu
Date: Fri, 20 Jun 2025 19:53:54 +0800

Correct the name for <zijun_hu@htc.com> from 'zijun_hu' to 'Zijun Hu'.

Link: https://lkml.kernel.org/r/20250620-my_mailmap-v1-2-11ea3db8ba1e@oss.qualcomm.com
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Cc: Hans verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-correct-name-for-a-historical-account-of-zijun-hu
+++ a/.mailmap
@@ -832,3 +832,4 @@ Zack Rusin <zack.rusin@broadcom.com> <za
 Zhu Yanjun <zyjzyj2000@gmail.com> <yanjunz@nvidia.com>
 Zijun Hu <zijun.hu@oss.qualcomm.com> <quic_zijuhu@quicinc.com>
 Zijun Hu <zijun.hu@oss.qualcomm.com> <zijuhu@codeaurora.org>
+Zijun Hu <zijun_hu@htc.com>
_

Patches currently in -mm which might be from zijun.hu@oss.qualcomm.com are


