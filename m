Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED13C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jan 2022 05:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiADFbq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jan 2022 00:31:46 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:46263 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiADFbq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2022 00:31:46 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JSh7N6MDqz4y46;
        Tue,  4 Jan 2022 16:31:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1641274305;
        bh=3jrOFsxgQs3KX8pb0Y/273v04d1zItbfem/bc7nsDLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IV0Vkeqrp1imBBcD/E0XY5hV1wsNPohRQXI0cmqfrSy9Z/8/cdASIxsKptE5xy6TY
         kd4/MUmHQFtGoRrv3FRoL+xnlF9qONl5hfF6EAs5sT1hhUjR8wx0t20r1kDpMtMNVr
         9F+UVl/QUaWuxsD9Kw07EUsAfNOw+A5rQLl98PRgzZDCboOCZSMV5o0IC14c3J+Ctt
         +JvPJegCffgg+N03irCXijc7wFwiJSWW8q7G0zNdPXVElDBOearCMmU9ynUuit7PPv
         wtEACuiXHMo2csyh5AW3xyk4YIg7Skbv1M4+Svx774ixWNeAdjDIgqkkvVkRDTbA1p
         9eW/2SRoEgB8A==
Date:   Tue, 4 Jan 2022 16:31:44 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, sj@kernel.org, rdunlap@infradead.org,
        mike.kravetz@oracle.com, baolin.wang@linux.alibaba.com
Subject: Re: + mm-damon-add-access-checking-for-hugetlb-pages-v3.patch added
 to -mm tree
Message-ID: <20220104163144.394d6b51@canb.auug.org.au>
In-Reply-To: <20211231021851.AfPOD%akpm@linux-foundation.org>
References: <20211231021851.AfPOD%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/VLlvfjtVlGhYdKvzVPX/j0t";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/VLlvfjtVlGhYdKvzVPX/j0t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 30 Dec 2021 18:18:51 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm-damon-add-access-checking-for-hugetlb-pages-v3
> has been added to the -mm tree.  Its filename is
>      mm-damon-add-access-checking-for-hugetlb-pages-v3.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/VLlvfjtVlGhYdKvzVPX/j0t
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHT28AACgkQAVBC80lX
0Gyk7wf/elm9EyyIJ/W5HFsL8UqprGPMKtBfNOwUY61OiGk5uiMcZrf9+TUTAtRK
FM2gzYZs4BM/S+LgdR16DHv8MaPCP/PlvRh8KQhPFqAxwLuneAM8KYmyCkwj0tWI
Z7Ov9cnXhj0S7jk8dKgji0G4ki/QFrZF1KE7Znn+SV6721LNnX8L18c3204XDvMS
zq2n0xHoPlcb3O3g+aLRRAtl5hXUgerAGFmWU0TzP6V0i4X7fu6X3OzXozuMurCI
MBrh+TkD/TS+tuMaeziAlXmUmfNF7IuLCVaylQrhMV1jhUgAsUnXovDLak2ujJJe
QXJYm1H/j5lCpEIA0arZyNpjIGDIvw==
=2wtW
-----END PGP SIGNATURE-----

--Sig_/VLlvfjtVlGhYdKvzVPX/j0t--
