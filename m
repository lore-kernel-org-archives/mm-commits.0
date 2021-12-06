Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C9AC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Dec 2021 07:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238504AbhLFHob (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Dec 2021 02:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238503AbhLFHob (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Dec 2021 02:44:31 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32D9C0613F8
        for <mm-commits@vger.kernel.org>; Sun,  5 Dec 2021 23:41:02 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J6wMx10Msz4xPw;
        Mon,  6 Dec 2021 18:41:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638776461;
        bh=l2gZnx6wFKIkL5G4DL4sn5+HqoS3azONRPLeULJfoxI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mid/y0ffVPhYAxnhWXFAebLL5FBp+rSDDfAin5xuozG4nhDTAigJWrCHGAgWVtMxs
         9cqJzSqQlrQ6AC6Wj+LGguKh9NRrNuDGzsTddFOlzVPS34naGZ2vyAOTwPwwzuRIDf
         0/xxdQ2dJt2G2ooJKzLlMywDm0IjyddGM0JD+EC2Wg4iiVMrSTypx3scj74uVXAuEy
         10WnDn6OaSF0RnhqWf8bpxEyA+ltgP3SEfgFX+ocI5fAf3+USYLXgs4KSlE9iu1rDl
         XIeojdH3pJIZUnvr9cVk4pm6wSawxwOSD6TvcPDjTD8eHFXWlA2o33SW/f6Z+YoEvv
         dvLYpoz+Yi7Mw==
Date:   Mon, 6 Dec 2021 18:41:00 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     almasrymina@google.com, keescook@chromium.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com
Subject: Re: + hugetlb-add-hugetlbnuma_stat-file-fix-2.patch added to -mm
 tree
Message-ID: <20211206184100.16c1f078@canb.auug.org.au>
In-Reply-To: <20211203204219.RoCYi90-H%akpm@linux-foundation.org>
References: <20211203204219.RoCYi90-H%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/SDtQKi81YD4oMzICkzcgFhk";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/SDtQKi81YD4oMzICkzcgFhk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 03 Dec 2021 12:42:19 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: hugetlb/cgroup: fix copy/paste array assignment
> has been added to the -mm tree.  Its filename is
>      hugetlb-add-hugetlbnuma_stat-file-fix-2.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/SDtQKi81YD4oMzICkzcgFhk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGtvowACgkQAVBC80lX
0GzQJAf8CFlrIEwMKukKhEJCVnFiZUGCCmM9ezhxoA54gDLi+A94l12OI8mPQo2/
BIJNLAWlLvyUGfqtGqdIBQL23FD/hAMExdiqCPKLAt4ZWXaAU70EG4E/yoSNmccn
GzytYq1UX7G4VvI/ixOuqMwVol8x3e0Q9oN1FfcJB0Os3vrjWnMhmY6pMRSlUx0b
FxTg6PpIMbtSK2L3e4/BntnHfmOu2U/30U9jwjDns+aD8t2HmJod0c1qpEVZwcEV
daTcg9k6M3TobS+HdtX9xgsTRjOEFk17d5t2xZgPIyQyTCim8yCAMU2ArRdhhCRo
xlWpbYlYiyusXCz+zJ6k/r086b+RgQ==
=9OIx
-----END PGP SIGNATURE-----

--Sig_/SDtQKi81YD4oMzICkzcgFhk--
